#! /usr/bin/env python
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
from boogie.z3_embed import expr_to_z3, AllIntTypeEnv, ids, z3_expr_to_boogie, shutdownZ3
from boogie.paths import sp_nd_ssa_path, nd_bb_path_to_ssa, wp_nd_ssa_path
from boogie.ssa import SSAEnv
from graph import strongly_connected_components, collapse_scc, topo_sort
from sys import exc_info
from cProfile import Profile
from pstats import Stats
from StringIO import StringIO
from random import choice

from levels import _tryUnroll, loadBoogies, loadTraces, findNegatingTrace, loadBoogieLvlSet

import argparse
import traceback
import time
import sys
from pp import *
from copy import copy
from colorama import Fore,Back,Style
from colorama import init as colorama_init

colorama_init();

p = argparse.ArgumentParser(description="invariant gen game server")
p.add_argument('--log', type=str, help='an optional log file to store all user actions. Entries are stored in JSON format.')
p.add_argument('--port', type=int, help='an optional port number')
p.add_argument('--ename', type=str, default = 'default', help='Name for experiment; if none provided, use "default"')
p.add_argument('--lvlset', type=str, default = 'desugared-boogie-benchmarks', help='Lvlset to use for serving benchmarks"')

args = p.parse_args();

logF = None;
if args.log:
    logF = open(args.log,'w')

def arg_tostr(arg):
    return str(arg);

def log(action, *pps):
    action['time'] = time.time()
    action['ip'] = request.remote_addr;
    if (logF):
        logF.write(dumps(action) + '\n')
        logF.flush()
    else:
        if (len(pps) == 0):
          print dumps(action) + "\n";
        else:
          assert(len(action['kwargs']) == 0);
          assert(len(pps) >= len(action['args']));
          prompt = "[" + Fore.GREEN + str(action['ip']) + Style.RESET_ALL + '] ' + \
              Style.DIM + str(action['time']) + Style.RESET_ALL + ':'

          call = Fore.RED + action['method'] + "(" + Style.RESET_ALL \
              + (Fore.RED + "," + Style.RESET_ALL).join(\
                  [pps[ind](arg) for (ind, arg) in enumerate(action["args"])]) + \
               Fore.RED + ")" + Style.RESET_ALL

          if (len(action['args']) + 1 == len(pps) and 'res' in action):
            call += "=" + pps[len(action['args'])](action['res']);

          print prompt + call;
        sys.stdout.flush();

def log_d(*pps):
    def decorator(f):
        def decorated(*args, **kwargs):
            try:
                res = f(*args, **kwargs)
                log({ "method": f.__name__, "args": args, "kwargs": kwargs, "res": res }, *pps)
                return res;
            except Exception,e:
                log({ "method": f.__name__, "args": args, "kwargs": kwargs,
                      "exception": ''.join(traceback.format_exception(*exc_info()))})
                raise
        return decorated
    return decorator

def prof_d(f):
    def decorated(*args, **kwargs):
        try:
            pr = Profile()
            pr.enable()
            res = f(*args, **kwargs)
            pr.disable()
            return res;
        except Exception,e:
            raise
        finally:
            # Print results
            s = StringIO()
            ps = Stats(pr, stream=s).sort_stats('cumulative')
            ps.print_stats()
            print s.getvalue()
    return decorated

MYDIR = dirname(abspath(realpath(__file__)))
ROOT_DIR = dirname(MYDIR)

curLevelSetName, lvls = loadBoogieLvlSet(args.lvlset)
traces = { curLevelSetName: lvls }

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.logEvent")
@pp_exc
@log_d(str,str,str,str)
def logEvent(workerId, name, data):
    return None

@api.method("App.listData")
@pp_exc
@log_d(str,str)
def listData(levelSet):
    res = traces[levelSet].keys()
    res.sort()
    return res

@api.method("App.getTutorialDone")
@pp_exc
@log_d(str, str)
def getTutorialDone(workerId):
    if workerId == "":
        return False
    return isfile(join(ROOT_DIR, 'logs', args.ename, "tut-done-" + workerId))

@api.method("App.setTutorialDone")
@pp_exc
@log_d(str)
def setTutorialDone(workerId):
    if workerId != "":
        open(join(ROOT_DIR, 'logs', args.ename, "tut-done-" + workerId), "w").close()

# @api.method("App.getMyNextLvl")
# @pp_exc
# @log_d()
# def getMyNextLvl(workerId, levelSet):
#     if workerId == "":
#         return "Tutorial"
#     if (levelSet not in traces):
#         raise Exception("Unkonwn level set " + levelSet)
#     fname = join(ROOT_DIR, 'logs', args.ename, workerId)
#     try:
#         with open(fname) as f:
#             last = f.read()
#     except IOError:
#         return "Tutorial"
#     levelIds = traces[levelSet].keys()
#     levelIds.sort()
#     levelIds = ["Tutorial"] + levelIds
#     try:
#         i = levelIds.index(last)
#         return levelIds[i+1]
#     except (ValueError, IndexError):
#         return "None"

# @api.method("App.getMyLastLvl")
# @pp_exc
# @log_d()
# def getMyLastLvl(workerId, levelSet):
#     # note that we ignore levelSet -- for now assume each
#     # experiment uses a single levelSet
#     if workerId == "":
#         return "None"
#     if (levelSet not in traces):
#         raise Exception("Unkonwn level set " + levelSet)
#     fname = join(ROOT_DIR, 'logs', args.ename, workerId)
#     try:
#         with open(fname) as f:
#             return f.read()
#     except IOError:
#         return "None"


# @api.method("App.storeMyLastLvl")
# @pp_exc
# @log_d()
# def storeMyLastLvl(workerId, levelSet, lvlId):
#     # note that we ignore levelSet -- for now assume each
#     # experiment uses a single levelSet
#     if workerId == "":
#         return
#     fname = join(ROOT_DIR, 'logs', args.ename, workerId)
#     with open(fname, "w") as f:
#         f.write(lvlId)

@api.method("App.loadLvl")
@pp_exc
@log_d(str, str, pp_BoogieLvl)
def loadLvl(levelSet, lvlId):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + levelSet)

    if (lvlId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + lvlId + " in levels " + levelSet)

    lvl = traces[levelSet][lvlId]
    if ('program' in lvl):
      # This is a boogie level - don't return the program/loop and other book keeping
      lvl = {
             'variables': lvl['variables'],
             'data': lvl['data'],
             'exploration_state': lvl['exploration_state'],
             'hint': lvl['hint'],
             'goal' : lvl['goal'],
             'support_pos_ex' : lvl['support_pos_ex'],
             'support_neg_ex' : lvl['support_neg_ex'],
             'support_ind_ex' : lvl['support_ind_ex'],
             'multiround'     : lvl['multiround'],
      }

    return lvl

class IgnoreManager:
    def __init__(self):
        self.ignores = {}
    def fname(self, workerId):
        return join(ROOT_DIR, 'logs', args.ename, "ignore-" + workerId)
    def ignoreset(self, workerId):
        if not workerId in self.ignores:
            self.load_from_file(workerId)
        return self.ignores[workerId]
    def load_from_file(self, workerId):
        res = set()
        try:
            with open(self.fname(workerId)) as f:
                for l in f.readlines():
                    res.add(tuple(l.split()))
        except IOError:
            pass # file does not exist, this is just empty ignore set
        self.ignores[workerId] = res
    def add(self, workerId, levelSet, lvlId):
        self.ignoreset(workerId).add((levelSet, lvlId))
        with open(self.fname(workerId), "a") as f:
            f.write(levelSet + " " + lvlId + "\n")
    def contains(self,workerId, levelSet, lvlId):
        return (levelSet, lvlId) in self.ignoreset(workerId)

@api.method("App.loadNextLvl")
@pp_exc
@log_d(str, pp_BoogieLvl)
def loadNextLvl(workerId):
    exp_dir = join(ROOT_DIR, "logs", args.ename)
    level_names = traces[curLevelSetName].keys();
    level_names.sort()
    for lvlId in level_names:
        if isfile(join(exp_dir, "done-" + curLevelSetName + "-" + lvlId)):
            continue
        if workerId != "" and ignore.contains(workerId, curLevelSetName, lvlId):
            continue
        result = loadLvl(curLevelSetName, lvlId)
        result["id"] = lvlId
        result["lvlSet"] = curLevelSetName
        return result

@api.method("App.addToIgnoreList")
@pp_exc
@log_d(str, str, str)
def addToIgnoreList(workerId, levelSet, lvlId):
    if workerId != "":
        ignore.add(workerId, levelSet, lvlId)

@api.method("App.setLvlAsDone")
@pp_exc
@log_d(str, str)
def setLvlAsDone(levelSet, lvlId):
    open(join(ROOT_DIR, "logs", args.ename, "done-" + levelSet + "-" + lvlId), "w").close()

def _from_dict(vs, vals):
    if type(vals) == tuple:
        return ( _from_dict(vs, vals[0]), _from_dict(vs, vals[1]) )
    else:
        return [ vals[vs[i]].as_long() if vs[i] in vals else None for i in xrange(0, len(vs)) ]

@api.method("App.instantiate")
@pp_exc
@log_d(pp_EsprimaInvs, str, str)
def instantiate(invs, traceVars, trace):
    res = []
    z3Invs = []
    templates = [ (esprimaToBoogie(x[0], {}), x[1], x[2]) for x in invs]
    vals = map(lambda x:    _to_dict(traceVars, x), trace)

    for (bInv, symConsts, symVars) in templates:
        for instInv in instantiateAndEval(bInv, vals, symVars, symConsts):
            instZ3Inv = expr_to_z3(instInv, AllIntTypeEnv())
            implied = False
            z3Inv = None

            for z3Inv in z3Invs:
                if implies(z3Inv, instZ3Inv):
                    implied = True;
                    break

            if (implied):   continue
            res.append(instInv)
            z3Invs.append(instZ3Inv)

    return map(lambda x: boogieToEsprima(x), res)
    
@api.method("App.getPositiveExamples")
@pp_exc
@log_d()
def getPositiveExamples(levelSet, levelId, cur_expl_state, overfittedInvs, num):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + " in levels " + str(levelSet))

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + str(levelSet) + " not a dynamic boogie level.")

    bbs = lvl['program']
    loop = lvl["loop"]
    found = []
    need = num
    heads = set([tuple(x[0]) for x in cur_expl_state])
    overfitBoogieInvs = [esprimaToBoogie(x, {}) for x in overfittedInvs]
    negatedVals, terminates = findNegatingTrace(loop, bbs, num, overfitBoogieInvs)

    if (negatedVals):
        cur_expl_state.insert(0, (_from_dict(lvl['variables'], negatedVals[0]), 0, False))

    for (ind, (loop_head, nunrolls, is_finished)) in enumerate(cur_expl_state):
        if is_finished: continue
        if need <= 0:   break

        good_env = _to_dict(lvl['variables'], loop_head)
        # Lets first try to find terminating executions:
        new_vals, terminating = _tryUnroll(loop, bbs, nunrolls+1, nunrolls+1+need, None, good_env)
        new_vals = new_vals[nunrolls+1:]
        cur_expl_state[ind] = (loop_head, nunrolls + len(new_vals), terminating)

        found.extend(new_vals)
        need -= len(new_vals)

    while need > 0:
        bad_envs = [ _to_dict(lvl['variables'], row) for (row,_,_) in cur_expl_state ]
        new_vals, terminating = _tryUnroll(loop, bbs, 0, need, bad_envs, None)
        found.extend(new_vals)
        need -= len(new_vals)
        if (len(new_vals) == 0):
            break
        cur_expl_state.append((_from_dict(lvl['variables'], new_vals[0]), len(new_vals)-1, terminating))

    # De-z3-ify the numbers
    js_found = [ _from_dict(lvl["variables"], env) for env in found]
    return (copy(cur_expl_state), js_found)

@api.method("App.equivalentPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_EsprimaInvPairs)
def equivalentPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if equivalent(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.impliedPairs")
@pp_exc
@log_d(pp_EsprimaInvs, pp_EsprimaInvs, pp_EsprimaInvPairs)
def impliedPairs(invL1, invL2):
    z3InvL1 = [esprimaToZ3(x, {}) for x in invL1]
    z3InvL2 = [esprimaToZ3(x, {}) for x in invL2]

    res = [(x,y) for x in z3InvL1 for y in z3InvL2 if implies(x, y)]
    res = [(boogieToEsprima(z3_expr_to_boogie(x)),
            boogieToEsprima(z3_expr_to_boogie(y))) for (x,y) in res]
    return res

@api.method("App.isTautology")
@pp_exc
@log_d(pp_EsprimaInv, str)
def isTautology(inv):
    res = (tautology(esprimaToZ3(inv, {})))
    return res

@api.method("App.tryAndVerify")
@pp_exc
@log_d(str, str, pp_EsprimaInvs, pp_tryAndVerifyRes)
def tryAndVerify(levelSet, levelId, invs):
    if (levelSet not in traces):
        raise Exception("Unkonwn level set " + str(levelSet))

    if (levelId not in traces[levelSet]):
        raise Exception("Unkonwn trace " + str(levelId) + " in levels " + str(levelSet))

    if (len(invs) == 0):
        raise Exception("No invariants given")

    lvl = traces[levelSet][levelId]

    if ('program' not in lvl):
      # Not a boogie level - error
      raise Exception("Level " + str(levelId) + " " + str(levelSet) + " not a dynamic boogie level.")

    boogie_invs = [ esprimaToBoogie(x, {}) for x in invs ]
    bbs = lvl['program']
    loop = lvl['loop']
    partialInvs = [ lvl['partialInv'] ] if 'partialInv' in lvl else []
    splitterPreds = lvl['splitterPreds'] if 'splitterPreds' in lvl else [ AstTrue() ]
    boogie_invs = [ esprimaToBoogie(x, {}) for x in invs ]
    candidate_antecedents = [ ast_and(pSet) for pSet in nonempty(powerset(splitterPreds)) ]

    # First lets find the invariants that are sound without implication
    overfitted, nonind, sound = tryAndVerify_impl(bbs, loop, [], boogie_invs)

    # Next lets add implication  to all unsound invariants from first pass
    # Also add manually specified partialInvs
    unsound = [ inv_ctr_pair[0] for inv_ctr_pair in overfitted + nonind ]
    p2_invs = [ AstBinExpr(antec, "==>", inv)
      for antec in candidate_antecedents for inv in unsound ] + partialInvs

    # And look for any new sound invariants
    overfitted, nonind, sound_p2 = tryAndVerify_impl(bbs, loop, sound, p2_invs)
    sound = sound.union(sound_p2)

    # Finally see if the sound invariants imply the postcondition. Don't forget to
    # convert any counterexamples from {x:1, y:2} to [1,2]
    fix = lambda x: _from_dict(lvl['variables'], x)
    boogie_inv = ast_and(sound)
    post_ctrex = map(fix, filter(lambda x:    x, [ loop_vc_post_ctrex(loop, boogie_inv, bbs) ]))
    
    # Convert all invariants from Boogie to esprima expressions, and counterexamples to arrays
    # from dictionaries
    overfitted = [ (boogieToEsprima(inv), fix(ctrex)) for (inv, ctrex) in overfitted ]
    nonind = [ (boogieToEsprima(inv), map(fix, ctrex)) for (inv, ctrex) in nonind ]
    sound = [ boogieToEsprima(inv) for inv in sound ]

    res = (overfitted, nonind, sound, post_ctrex)
    return res

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
def tryAndVerify_impl(bbs, loop, sound, invs):
    # 0. First get the overfitted invariants out of the way. We can check overfitted-ness
    #    individually for each invariant.
    pre_ctrexs = map(lambda inv:    (inv, loop_vc_pre_ctrex(loop, inv, bbs)), invs)
    overfitted, rest = split(lambda ((inv, ctrex)): ctrex != None, pre_ctrexs)
    rest = map(lambda x:    x[0], rest)

    # 1. Build an influences graph of the left-over invariants
    inflGraph = getInfluenceGraph(rest, loop, bbs)
    # 2. Build a collapsed version of the graph
    sccs = strongly_connected_components(inflGraph) 

    # 3. Sort collapsed graph topologically
    collapsedInflGraph = collapse_scc(inflGraph, sccs)

    # 5. For each collapsed s.c.c in topo order (single invariants can be viewed as a s.c.c with 1 elmnt.)
    check_order = topo_sort(collapsedInflGraph)

    sound_invs = set(sound)
    nonind_ctrex = { }

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
            conj = ast_and(list(sound_invs) + inv_subs)
            ind_ctrex = loop_vc_ind_ctrex(loop, conj, bbs)
            nchecks_infl_graph_set_skipping += 1
            # If conjunction is inductive:
            if (not ind_ctrex):
                # Add all invariants in conj. in sound set.
                sound_invs = sound_invs.union(inv_subs);
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
        if inv not in overfitted_set and inv not in sound_invs:
            nonind_invs.append((inv, nonind_ctrex[inv]))

    print "NChecks: Worst: ", nchecks_worst, "InflGraph: ", nchecks_infl_graph,\
          "InflGraph+SetSkip:", nchecks_infl_graph_set_skipping, "Best:", nchecks_best 

    return overfitted, nonind_invs, sound_invs
    
@api.method("App.simplifyInv")
@pp_exc
@log_d(pp_EsprimaInv, pp_EsprimaInv)
def simplifyInv(inv):
    z3_inv = esprimaToZ3(inv, {});
    simpl_z3_inv = simplify(z3_inv, arith_lhs=True);
    return boogieToEsprima(z3_expr_to_boogie(simpl_z3_inv));

@api.method("App.getRandomCode")
@pp_exc
@log_d(str)
def getRandomCode():
    alphanum = "".join([chr(ord('a') + i) for i in range(26) ] + [ str(i) for i in range(0,10)])
    return "".join([ choice(alphanum) for x in range(5) ]);

if __name__ == "__main__":
    ignore = IgnoreManager()
    app.run(host='0.0.0.0',port=args.port,ssl_context=(MYDIR + '/cert.pem', MYDIR + '/privkey.pem'), threaded=True)
    shutdownZ3();
