class StickyWindow {
  constructor(public parent:  HTMLElement) {
    $(this.parent).addClass("box")
    $(this.parent).addClass("stickyWindow");
    $(this.parent).addClass("col-md-1");
    this.clear();
  }

  add(pwup: IPowerup): void {
    $(this.parent).append(pwup.element)
  }

  set(pwups: IPowerup[]): void {
    let d:JQuery = $("<div><p style='text-align: center; font-weight: bold; margin-top: 8px'>Powerups</p><br></div>")
    for (var i in pwups)
      d.append(pwups[i].element)

    $(this.parent).html("");
    $(this.parent).append(d);
  }

  clear():void {
    $(this.parent).html("<p style='text-align: center; font-weight: bold; margin-top: 8px'>Powerups</p><br>");
  }
}
