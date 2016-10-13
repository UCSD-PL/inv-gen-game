from flask import Flask
from flask import request
from flask_jsonrpc import JSONRPC as rpc
from os.path import *
from json import load, dumps
from js import invJSToZ3, addAllIntEnv, esprimaToZ3, esprimaToBoogie, boogieToEsprima
from boogie.ast import parseAst, AstBinExpr, AstTrue, AstUnExpr,\
    ast_and, replace, expr_read
from boogie_loops import loop_vc_pre_ctrex, loop_vc_post_ctrex, loop_vc_ind_ctrex
from util import unique, pp_exc, powerset, average, split, nonempty
from boogie.eval import instantiateAndEval, _to_dict
from boogie.z3_embed import expr_to_z3, AllIntTypeEnv, ids, z3_expr_to_boogie, shutdownZ3, tautology
from boogie.paths import sp_nd_ssa_path, nd_bb_path_to_ssa, wp_nd_ssa_path
from boogie.ssa import SSAEnv
from graph import strongly_connected_components, collapse_scc, topo_sort
from sys import exc_info
from cProfile import Profile
from pstats import Stats
from StringIO import StringIO
from random import choice

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]].as_long() if vs[i] in vals else None for i in xrange(0, len(vs)) ]

def getInfluenceGraph(invs, loop, bbs):
    body_ssa, ssa_env = nd_bb_path_to_ssa([ loop.loop_paths ], bbs, SSAEnv(None, ""))
    inv_wps = [ wp_nd_ssa_path(body_ssa, bbs,
                              expr_to_z3(replace(x, ssa_env.replm()), AllIntTypeEnv()),
                              AllIntTypeEnv())
                for x in invs ]
    infl_vars = [ set(ids(x)) for x in inv_wps ]
    expr_vars = [ expr_read(x) for x in invs ]
    influences = { i : set() for i in xrange(len(invs)) }

    for i in xrange(len(invs)):
        for j in xrange(len(invs)):
            if (i == j):    continue
            if len(infl_vars[i].intersection(expr_vars[j])) > 0:
                # Expression j influences the outcome of expression i
                influences[i].add(j)

    return influences;

# TODO: Make this incremental
def tryAndVerify_impl(bbs, loop, old_sound_invs, invs):
    # 0. First get the overfitted invariants out of the way. We can check overfitted-ness
    #    individually for each invariant.
    pre_ctrexs = map(lambda inv:    (inv, loop_vc_pre_ctrex(loop, inv, bbs)), invs)
    overfitted, rest = split(lambda ((inv, ctrex)): ctrex != None, pre_ctrexs)
    rest = map(lambda x:    x[0], rest)

    print len(rest), " left after overfitted removed"

    # 1. Build an influences graph of the left-over invariants
    inflGraph = getInfluenceGraph(rest, loop, bbs)
    # 2. Build a collapsed version of the graph
    sccs = strongly_connected_components(inflGraph) 

    # 3. Sort collapsed graph topologically
    collapsedInflGraph = collapse_scc(inflGraph, sccs)

    # 5. For each collapsed s.c.c in topo order (single invariants can be viewed as a s.c.c with 1 elmnt.)
    check_order = topo_sort(collapsedInflGraph)

    new_sound_invs = set()
    nonind_ctrex = { }

    scc_nchecks = 0
    for scc in map(lambda i:    sccs[i], check_order):
        # 5.1 For all possible subsets of s.c.c.
        scc_nchecks += 2**len(scc)
    print "After s.c.c.s ", scc_nchecks, " will be performed"

    nchecks_worst = 2**len(invs)
    nchecks_infl_graph = 0
    nchecks_infl_graph_set_skipping = 0
    nchecks_best = len(invs);
    # TODO: Opportunities for optimization: Some elements can be viewed
    # in parallel. To do so - modified bfs on the influences graph
    for scc in map(lambda i:    sccs[i], check_order):
        # 5.1 For all possible subsets of s.c.c.
        ps = list(powerset(scc))
        nchecks_infl_graph += len(ps)
        sound_inv_inds = set()
        for subset in ps:
            if (len(subset) == 0):  continue
            # TODO: Opportunity for optimization: If you find a sound invariant
            # in a s.c.c, can you break up the s.c.c And re-sort just the s.c.c
            # topologically? Thus reduce the complexity?
            # THOUGHTS: With the current dependency definition (shared variables)
            # not likely, as I would expect most s.c.cs to be complete graphs.
            # TODO: Check if this is true /\

            # OPTIMIZATION: We can ignore any subset that doesn't contain
            # the currently discovered invariants. This is SAFE since
            # powerset orders sets in increasing size, thus if some
            # s doesn't contain a sound invariant i, then s + { i } follows
            # in the ordering, and if s is sound, the s + { i } is definitely sound.
            if (not sound_inv_inds.issubset(subset)): 
                continue

            inv_subs = [ rest[x] for x in subset ]
            conj = ast_and(list(new_sound_invs) + list(old_sound_invs) + inv_subs)
            ind_ctrex = loop_vc_ind_ctrex(loop, conj, bbs)
            nchecks_infl_graph_set_skipping += 1
            # If conjunction is inductive:
            if (not ind_ctrex):
                # Add all invariants in conj. in sound set.
                new_sound_invs = new_sound_invs.union(inv_subs);
                sound_inv_inds = sound_inv_inds.union(subset);
            else:
                d = subset.difference(sound_inv_inds)
                if (len(d) == 1):
                    # TODO: Is this part sound?
                    nonind_ctrex[rest[list(d)[0]]] = ind_ctrex

    # 6. Label remainder as non-inductive
    nonind_invs = [ ]
    overfitted_set = set([ x[0] for x in overfitted ])

    for inv in invs:
        if inv not in overfitted_set and inv not in new_sound_invs:
            nonind_invs.append((inv, nonind_ctrex[inv]))

    print "NChecks: Worst: ", nchecks_worst, "InflGraph: ", nchecks_infl_graph,\
          "InflGraph+SetSkip:", nchecks_infl_graph_set_skipping, "Best:", nchecks_best 

    return overfitted, nonind_invs, new_sound_invs
