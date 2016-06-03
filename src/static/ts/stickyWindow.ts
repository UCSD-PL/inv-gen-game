class StickyWindow extends BaseContainer<IPowerup> {
  addElement(key: string, pwup: IPowerup, rep: JQuery): HTMLElement {
    let div = $(this.parent).children("div")[0]
    $(div).append(pwup.element);
    return pwup.element[0];
  }

  removeElement(key: string, obj: IPowerup, element: HTMLElement): void {
    $(element).remove();
  }

  setPowerups(pwups: IPowerup[]): void {
    this.set(pwups.map((p):[string, IPowerup, JQuery] => [ p.id, p, p.element ]))
  }

  initEmpty():void {
    $(this.parent).addClass("box")
    $(this.parent).addClass("stickyWindow");
    $(this.parent).addClass("col-md-1");
    $(this.parent).html("<div><p style='text-align: center; font-weight: bold; margin-top: 8px'>Bonus</p><br></div>");
  }
}

class WideStickyWindow extends StickyWindow {
  initEmpty():void {
    $(this.parent).addClass("box")
    $(this.parent).addClass("stickyWindow");
    $(this.parent).addClass("col-md-2");
    $(this.parent).html("<p style='text-align: center; font-weight: bold; margin-top: 8px'>Bonus</p><br><div class='row'></div>");
    $(this.parent).tooltip();
  }

  addElement(key: string, pwup: IPowerup, rep: JQuery): HTMLElement {
    let div = $(this.parent).children("div")[0]
    let newDiv = $("<div class='col-md-4'></div>")
    $(newDiv).append(pwup.element);
    $(div).append(newDiv);
    return pwup.element[0];
  }
}
