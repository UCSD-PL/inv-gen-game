type invariantT = string;

interface IProgressWindow {
  addInvariant(invariant: invariantT): void;
  removeInvariant(invariant: invariantT): void;
  markInvariant(invariant: invariantT, state: string): void;
  clearMarks(): void;
  clear(): void;
  contains(invariant: invariantT):  boolean;
}

class ProgressWindow implements IProgressWindow {
  invMap: { [ inv: string]: HTMLElement } = { };
  container: HTMLElement;
  ctr: number = 0;

  constructor(public parent:  HTMLDivElement) {
    $(this.parent).html("<div class='progressWindow box good centered positioned'>" +
                      "Accepted expressions<br>" +
                      "<ul id='good-invariants'></ul>" +
                   "</div>");
    this.container = $(this.parent).children("div")[0];
  };

  addInvariant(invariant: invariantT): void {
    let invUl = $(this.container).children("#good-invariants")[0];
    $(invUl).append("<li class='good-invariant' id='good_" +
      this.ctr + "'>" + invToHTML(invariant) + "</li>");
    this.invMap[invariant] = $("#good_" + this.ctr)[0];
    this.ctr ++;
  }

  removeInvariant(invariant: invariantT): void {
    $(this.invMap[invariant]).remove();
    delete this.invMap[invariant];
  }

  markInvariant(invariant: invariantT, state: string): void {
    let invDiv = $(this.invMap[invariant]);

    if (invDiv === undefined) {
      console.log("Unknown invariant " + invariant);
      return;
    }

      if (state === "checking") {
      } else if (state === "duplicate") {
        invDiv.addClass("error");
      } else if (state === "tautology") {
      } else if (state === "implies") {
        invDiv.addClass("error");
      } else if (state === "counterexampled") {
        invDiv.addClass("error");
      } else if (state === "ok") {
        invDiv.removeClass("error");
      }
  }

  clearMarks(): void {
    for (let i in this.invMap) {
      $(this.invMap[i]).removeClass("error");
    }
  }

  clear(): void {
    let invUL: HTMLElement = $(this.container).children("#good-invariants")[0];
    $(invUL).html("");
    this.invMap = {};
    this.ctr = 0;
  }

  contains(invariant: invariantT): boolean {
    return this.invMap.hasOwnProperty(invariant);
  }
}


class TwoPlayerProgressWindow extends ProgressWindow {
  player: number;

  constructor(public playerNum: number, public parent:  HTMLDivElement) {
    super(parent);
    this.player = playerNum;
    $(this.parent).html("");

    $(this.parent).addClass("box");
    $(this.parent).addClass("progressWindow");

    if (this.player === 1) {
      $(this.parent).html("Invariants<br>" +
        "<ul id='good-invariants' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
    }
    else if (this.player === 2) {
      $(this.parent).html("Invariants<br>" +
        "<ul id='good-invariants2' style='font-family: monospace; list-style-type: none; padding: 0px; text-align: center;'></ul>");
    }

    this.container = $(this.parent).children("div")[0];
  }

  addInvariant(invariant: invariantT): void {
    let invUl = null;

    if (this.player === 1) {
      // invUl = $(this.container).children("#good-invariants")[0];
      invUl = $("#good-invariants");
    }
    else if (this.player === 2) {
      // invUl = $(this.container).children("#good-invariants2")[0];
      invUl = $("#good-invariants2");
    }

    $(invUl).append("<li class='good-invariant' id='good_" + this.player +
      this.ctr + "'>" + invToHTML(invariant) + "</li>");

    this.invMap[invariant] = $("#good_" + this.player + this.ctr)[0];
    this.ctr ++;
  }

  markInvariant(invariant: invariantT, state: string): void {
    let invDiv = $(this.invMap[invPP(invariant)]);
    // let invDiv = $(this.invMap[invariant]);

    if (invDiv === undefined) {
      console.log("Unknown invariant " + invariant);
      return;
    }

      if (state === "checking") {
      } else if (state === "duplicate") {
        invDiv.addClass("bold");
      } else if (state === "tautology") {
      } else if (state === "implies") {
        invDiv.addClass("bold");
      } else if (state === "counterexampled") {
        invDiv.addClass("bold");
      } else if (state === "ok") {
        invDiv.removeClass("bold");
      }
  }

  clearMarks(): void {
    for (let i in this.invMap) {
      $(this.invMap[i]).removeClass("bold");
    }
  }

  clear(): void {
    let invUL = null;
    if (this.player === 1) {
      invUL = $("#good-invariants");
    }
    else if (this.player === 2) {
      invUL = $("#good-invariants2");
    }
    $(invUL).html("");
    this.invMap = {};
    this.ctr = 0;
  }
}
