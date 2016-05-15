class ScoreWindow {
  score : number = 0;
  constructor(public parent: HTMLElement) {
    $(this.parent).html("")
    $(this.parent).addClass("scoreWindow")
    $(this.parent).addClass("scoreText")
    this.clear();
  }

  add(num: number): void {
    this.score += num;
    $(this.parent).html("<span>" + this.score + "</span>");
    let addSpan = $("<span class='scoreText scoreFloat'>+" + num + "</span>")
    $(this.parent).append(addSpan)
    addSpan.hide({ effect: "puff", easing:"swing", duration:1000, complete: function() { 
      $(addSpan).remove();
    }})
  }

  clear(): void {
    this.score = 0;
    $(this.parent).html("<span>0</span>")
  }
}
