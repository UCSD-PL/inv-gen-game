import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB, from_json} from "./boogie";
import {parse} from "esprima"
import {invariantT} from "./types"

rpc_loadLvlBasic("unsolved-new-benchmarks2", "i-sqrt", (lvl) => {
  let fun = from_json(lvl[1]);
  console.log(fun);
  console.log(lvl[2]);

  let headers: string[] = [];

  for (let k in lvl[2]) {
    if (lvl[2].hasOwnProperty(k)) {
      headers.push(k);
    }
  }
  console.log(headers)

  let invNetwork : { [label: string] : invariantT[] } = { };

  for (let lbl of headers) {
    invNetwork[lbl] = [parse("false")];
  }
  rpc_checkSoundness("unsolved-new-benchmarks2", "i-sqrt", invNetwork, (res) => {
    console.log("checkSoundness: ", res);
  })
})
