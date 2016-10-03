implementation cegar1(x0: int, y0: int)
{
  var x: int;
  var y: int;


  anon0:
    x := x0;
    y := y0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    x := x + 2;
    y := y + 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assert !(x == 4 && y == 0);
    return;
}

