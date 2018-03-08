import {rpc_loadLvlBasic, rpc_checkSoundness} from "./rpc";
import {Fun, BB, from_json} from "./boogie";
import {parse} from "esprima"
import {invariantT} from "./types"
import * as Phaser from "phaser"

class SimpleGame {
  constructor() {
    this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content', { preload: this.preload, create: this.create });
  }

  game: Phaser.Game;

  preload() {
    this.game.load.image('logo', 'img/no_cloud.jpg');
  }

  create() {
    console.log("Create");
    var logo = this.game.add.sprite(this.game.world.centerX, this.game.world.centerY, 'logo');
    logo.anchor.setTo(0.5, 0.5);
  }
}

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

$(document).ready(function() {
  let game = new SimpleGame();
})
