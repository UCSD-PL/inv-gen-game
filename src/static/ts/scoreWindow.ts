class ScoreWindow {
  score: number = 0;
  constructor(public parent: HTMLElement) {
    $(this.parent).html("");
    $(this.parent).addClass("scoreWindow");
    $(this.parent).addClass("scoreText");
    this.clear();
  }

  add(num: number): void {
    this.score += num;
    $(this.parent).html("<span>" + this.score + "</span>");
    let addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>")
    $(this.parent).append(addSpan)
    addSpan.position({ "my": "left center", "at": "right+10 center", "of": this.parent })
    addSpan.hide({ effect: "puff", easing:"swing", duration:2000, complete: function() { 
      $(addSpan).remove();
    }
    });
  }

  clear(): void {
    this.score = 0;
    $(this.parent).html("<span id='scoreNum'>0</span>");
  }
}

class NPlayerScoreWindow extends ScoreWindow {
  players: any = {}

  constructor(public parent: HTMLElement) {
    super(parent);
    $("#scoreboard-div-row").append("<div id=\"scoreboard\"></div>");
  }

  comparePlayers(a: any, b: any) {
    if (a.score < b.score) {
      return -1;
    }
    else if (a.score > b.score) {
      return 1;
    }
    return 0;
  }

  updatePlayers(players: any) {
    this.players = players.sort(this.comparePlayers);
    let scoreboard: string = "";
    let playerStats: string = "";
    let tblHead: string = "Scoreboard<table class='table table-borderless table-condensed'><tr><th>Rank</th><th>Player</th><th>Score</th></tr>";
    let tblTail: string = "</table>"
    for (let player = 0, len = this.players.length; player < len; player++) {
      playerStats = "<tr><td>" + (len - player) + "</td><td>" + this.players[player].id + "</td><td>" + this.players[player].score + "</td></tr>" + playerStats;
    }
    scoreboard = tblHead + playerStats + tblTail;
    $("#scoreboard").html(scoreboard);
  }
}

class TwoPlayerScoreWindow extends ScoreWindow {
  player: number = 0;

  constructor(public playerNum: number, public parent: HTMLElement) {
    super(parent);
    this.player = playerNum;

    $(this.parent).removeClass("scoreWindow");
    $(this.parent).removeClass("scoreText");

    if (this.player === 1) {
      $(this.parent).addClass("scoreWindow1");
      $(this.parent).addClass("scoreText1");
    }
    else if (this.player === 2) {
      $(this.parent).addClass("scoreWindow2");
      $(this.parent).addClass("scoreText2");
    }
  }

  add(num: number): void {
    this.score += num;
    $(this.parent).html("<span>" + this.score + "</span>");

    let addSpan = null;

    if (this.player === 1) {
      addSpan = $("<span class='scoreText1 scoreFloat'>+" + num + "</span>");
    }
    else if (this.player === 2) {
      addSpan = $("<span class='scoreText2 scoreFloat'>+" + num + "</span>");
    }

    $(this.parent).append(addSpan);

    addSpan.hide({
      effect: "puff", easing: "swing", duration: 1000, complete: function() {
      $(addSpan).remove();
    }
    });
  }
}
