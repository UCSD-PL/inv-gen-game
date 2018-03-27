import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB} from "./boogie";
import {parse} from "esprima"
import {Node as ESNode} from "estree";
import {invariantT} from "./types"
import * as Phaser from "phaser"
import {Point} from "phaser";
import {topo_sort, bfs, path} from "./graph";
import {Expr_T} from "./boogie";
import {getUid, StrMap, assert, max, intersection, single, diff, diff2, union2, copyMap2, mapMap2, copyMap, difference2, reversed, structEq} from "./util"
import {Node, ExprNode, AssignNode, IfNode, AssumeNode, UserNode,
        AssertNode, buildGraph, removeEmptyNodes, exit, NodeMap, PlaceholderNode} from "./game_graph"
import {TextIcon} from "./texticon"
import {SimpleGame} from "./invgraph_game"

$(document).ready(function() {

  let lvlName = "i-sqrt"
  let lvlSet = "unsolved-new-benchmarks2"
  /*
  let lvlName = "tut01"
  let lvlSet = "tutorial"
  */
  rpc_loadLvlBasic(lvlSet, lvlName, (lvl) => {
    let fun = Fun.from_json(lvl[1]);
    let [graph_entry, mapping] = buildGraph(fun);
    console.log("Initial:", graph_entry);
    [graph_entry, mapping] = removeEmptyNodes(graph_entry, mapping, true);
    console.log("After cleanup of empty nodes:", graph_entry);
    let game = new SimpleGame(graph_entry, mapping, fun, lvlName);
  })
})