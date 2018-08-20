import {invariantT} from "./types";
import {invToHTML} from "./pp";

export interface IProgressWindow {
  addInvariant(key: string, invariant: invariantT, playerEntered: string): void;
  removeInvariant(key: string): void;
  markInvariant(key: string, state: string): void;
  clearMarks(): void;
  clear(): void;
  contains(key: string):  boolean;
}

export class ProgressWindow implements IProgressWindow {
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

  addInvariant(key: string, invariant: invariantT, playerEntered: string) : void {
    let invUl = $(this.container).children("#good-invariants")[0];
      $(invUl).append("<li class='good-invariant' id='good_" +
      this.ctr + "'>" + playerEntered + "</li>");
      this.invMap[key] = $('#good_' + this.ctr)[0];
      this.ctr ++;
  }

  removeInvariant(key: string): void {
    $(this.invMap[key]).remove();
    delete this.invMap[key];
  }

  
  markInvariant(key: string, state: string): void {
    let invDiv = $(this.invMap[key]);

    if (invDiv == undefined) {
      console.log("Unknown invariant " + key);
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

  contains(key: string):  boolean {
    return this.invMap.hasOwnProperty(key);
  }
}

class IgnoredInvProgressWindow extends ProgressWindow {
  ignoredContainer: HTMLElement;
  constructor(public parent:  HTMLDivElement) {
    super(parent);
    $(this.parent).html("<div class='progressWindow box good centered positioned'>" +
                      "Accepted expressions<br>" +
                      "<ul id='good-invariants'></ul>"+
                   "</div>" +
                   "<div class='ignoreWindow box warn centered positioned'>" +
                      "Ignored expressions<br>" +
                      "<ul id='ignored-invariants'></ul>" +
                   "</div>");
    this.container = $(this.parent).children("div")[0];
      this.ignoredContainer = $(this.parent).children("div")[1];
  };

  addIgnoredInvariant(key: string, inv: invariantT) {
    let invUL: HTMLElement = $(this.ignoredContainer).children("ul")[0];
      $(invUL).append("<li class='ignored-invariant' id='ign_" +
      this.ctr + "'>" + invToHTML(inv) + "</li>");
      this.invMap[key] = $('#ign_' + this.ctr)[0];
      this.ctr++;
  }

  clear(): void {
    super.clear();
    let invUL: HTMLElement = $(this.ignoredContainer).children("ul")[0];
      $(invUL).html('');
  }
}