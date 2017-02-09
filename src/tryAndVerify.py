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
from lib.common.util import unique, pp_exc, powerset, average, split, nonempty
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
from vc_check import tryAndVerify_impl, _from_dict

from levels import _tryUnroll, loadBoogies, loadTraces, findNegatingTrace, loadBoogieLvlSet

import argparse
import traceback
import time
import sys
from pp import *
from copy import copy

p = argparse.ArgumentParser(description="invariant gen game server")
p.add_argument('--lvlset', type=str, default = 'desugared-boogie-benchmarks', help='Lvlset to use"')
p.add_argument('--lvlid', type=str, default = 'desugared-boogie-benchmarks', help='Lvl-id in level set to try and verify"')
p.add_argument('invs', type=str, nargs="+", help="Invariants to try")

args = p.parse_args();

_, lvls = loadBoogieLvlSet(args.lvlset)
lvl = lvls[args.lvlid]
bbs = lvl['program']
loop = lvl['loop']
partialInvs = [ lvl['partialInv'] ] if 'partialInv' in lvl else []
splitterPreds = lvl['splitterPreds'] if 'splitterPreds' in lvl else [ AstTrue() ]
boogie_invs = [ parseExprAst(x) for x in args.invs ]
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

print "Sound: ", sound
print "Verified? ", len(sound) > 0 and len(post_ctrex) == 0
