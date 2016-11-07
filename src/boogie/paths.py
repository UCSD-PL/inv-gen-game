from ast import *;
from boogie.z3_embed import *
from bb import *
from ssa import *
from predicate_transformers import wp_stmts, sp_stmts

# BB_PATH = [ BB_LABEL ]
# NONDET_BB_PATH = [ (BB | [ NONDET_BB_PATH ] ) ]
# NONDET_SSA_BB_PATH = [ (BB, [ REPL_M ]) | ( CHOICE_VAR, [ NONDET_SSA_BB_PATH ] ) ]

def nd_bb_path_to_ssa(p, bbs, ssa_env, cur_p = ""):
    path = []
    for ind, arg in enumerate(p):
        if isinstance(arg, str):
            repl_ms = [ ssa_env.replm() ]
            for stmt in bbs[arg].stmts:
                for name in stmt_changed(stmt):
                    ssa_env.update(name)
                    new_name = ssa_env.lookup(name)
                repl_ms.append(ssa_env.replm())
            path.append((arg, repl_ms))
        else:
            tmp = []
            choice_var = "_split_" + cur_p + "." + str(ind)

            # Build each SSA-ed subpath
            for nsplit, subp in enumerate(arg):
                suffix = cur_p + "." + str(ind) + "." + str(nsplit) + "."
                tmp.append(nd_bb_path_to_ssa(subp, bbs, SSAEnv(ssa_env, suffix), cur_p + suffix))

            # Compute the set of variables changed across ALL paths
            changed = set()
            for (_, sub_env) in tmp:  changed.update(sub_env.changed())

            # Compute their ssa name BEFORE the paths
            old_varm = { s : ssa_env.lookup(s) for s in changed }
            # Make sure each of them is upded in the environment AFTER the paths
            for s in changed: ssa_env.update(s)

            # For each sub-path add a "union" block at the end
            # that makes sure the SSA-ed names of all changed variables
            # across all paths match up
            for (nsplit, (subp, sub_env)) in enumerate(tmp):
                bb_name = "_union_"  + cur_p + "." + str(ind) + "." + str(nsplit)
                bb_stmts = []
                bb_replmps = [ sub_env.replm() ]

                for s in changed:
                    if (s in sub_env.changed()):
                        old_var = sub_env.lookup(s)
                        sub_env.remove(s)
                    else:
                        old_var = old_varm[s]

                    bb_stmts.append(AstAssignment(AstId(ssa_env.lookup(s)), AstId(old_var)))
                    bb_replmps.append(sub_env.replm())

                bb = BB(set(), bb_stmts, set())
                bbs[bb_name] = bb
                subp.append((bb_name, bb_replmps))
            path.append((choice_var, map(lambda x:  x[0], tmp)))

    return (path, ssa_env)

def ssa_stmt(stmt, prev_replm, cur_replm):
    # Havoc's turn into no-ops when SSA-ed.
    if isinstance(stmt, AstHavoc):
        return AstAssert(AstTrue);
    if isinstance(stmt, AstAssignment):
        return AstAssignment(replace(stmt.lhs, cur_replm), replace(stmt.rhs, prev_replm))
    else:
        return replace(stmt, cur_replm)

def _ssa_stmts(stmts, envs):
    return [ssa_stmt(stmts[i], envs[i], envs[i+1]) for i in xrange(0, len(stmts))]

def ssa_path_to_z3(ssa_path, bbs):
    def f(arg):
        if (arg[0].startswith("_split_")):
            split_var = arg[0]
            return Or([And((Int(split_var) == ind), ssa_path_to_z3(x, bbs))
                for ind, x in enumerate(arg[1])])
        else:
            return And([stmt_to_z3(stmt, AllIntTypeEnv())
                for stmt in _ssa_stmts(bbs[arg[0]].stmts, arg[1])])
    return And(map(f, ssa_path))

def is_nd_bb_path_possible(bbpath, bbs):
    nd_ssa_p, _ = nd_bb_path_to_ssa(bbpath, bbs, SSAEnv(None, ""))
    return satisfiable(ssa_path_to_z3(nd_ssa_p, bbs))

def extract_ssa_path_vars(ssa_p, m):
    argsS = set([str(x) for x in m if not is_ssa_str(str(x)) and '_split_' not in str(x)])

    def _helper(ssa_p):
        concrete_ssa_path = []
        for (ind, arg) in enumerate(ssa_p):
            if (arg[0].startswith("_split_")):
                choice_var, nd_paths = arg
                taken_ssa_path = nd_paths[m[choice_var]]
                concrete_ssa_path.extend(_helper(taken_ssa_path))
            else:
                (bb, repl_ms) = arg
                envs = []
                for repl_m in repl_ms:
                    vs = set(map(str, repl_m.keys())).union(argsS)
                    new_env = { orig_name : m.get(ssa_name, None) for (orig_name, ssa_name) in [(x, str(repl_m.get(AstId(x), x))) for x in vs ] }
                    envs.append(new_env);

                concrete_ssa_path.append((bb,envs)) 
        return concrete_ssa_path

    return [x for x in _helper(ssa_p) if '_union_' not in x[0]]
    

def get_path_vars(bbpath, bbs):
    ssa_p, _ = nd_bb_path_to_ssa(bbpath, bbs, SSAEnv(None, ""))
    m = model(ssa_path_to_z3(ssa_p, bbs))
    return extract_ssa_path_vars(ssa_p, m);

def wp_nd_ssa_path(ssa_p, bbs, pred, typeEnv):
    for arg in reversed(ssa_p):
        if (arg[0].startswith("_split_")):
            pred = Or([wp_nd_ssa_path(subp, bbs, pred, typeEnv) for subp in arg[1]])
        else:
            pred = wp_stmts(_ssa_stmts(bbs[arg[0]].stmts, arg[1]), pred, typeEnv)
    return pred

def sp_nd_ssa_path(ssa_p, bbs, pred, typeEnv):
    for arg in ssa_p:
        if (arg[0].startswith("_split_")):
            pred = Or([sp_nd_ssa_path(subp, bbs, pred, typeEnv) for subp in arg[1]])
        else:
            pred = sp_stmts(_ssa_stmts(bbs[arg[0]].stmts, arg[1]), pred, typeEnv)
    return pred

if __name__ == "__main__":
    from sys import exit
    bbs = get_bbs("if_desugared_noint.bpl")
    p = ['anon0', 'anon5_LoopHead', 'anon5_LoopBody', 'anon6_Then', \
            'anon5_LoopHead',  'anon5_LoopBody', 'anon6_Else', \
            'anon5_LoopHead',  'anon5_LoopDone']
    x = nd_bb_path_to_ssa(p, bbs, SSAEnv(None, ""))[0], "\n"
    #print x

    p1 = ['anon0', 'anon5_LoopHead', 'anon5_LoopBody', [['anon6_Then'], ['anon6_Else']], \
            'anon5_LoopHead',  'anon5_LoopDone']

    p2 = ['anon0', 'anon5_LoopHead', 'anon5_LoopBody', [['anon6_Then'], ['anon6_Else']], \
            'anon5_LoopHead', 'anon5_LoopBody', [['anon6_Then'], ['anon6_Else']], \
            'anon5_LoopHead',  'anon5_LoopDone']

    x = nd_bb_path_to_ssa(p1, bbs, SSAEnv(None, ""))[0]
    #print x, "\n"

    x= ssa_path_to_z3(nd_bb_path_to_ssa(p1, bbs, SSAEnv(None, ""))[0], bbs)
    try:
        get_path_vars(p1, bbs)
        print "This should have failed!"
        exit(-1);
    except:
        pass
    
    x = get_path_vars(p2, bbs)
