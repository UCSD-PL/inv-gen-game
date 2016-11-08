implementation main()
{
  var x: int;
  var y: int;
  var x0: int;
  var y0: int;


  anon0:
    assume 0 <= x0 && x0 <= 2 && 0 <= y0 && y0 <= 2;
    x := x0;
    y := y0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume true;
    x := x + 2;
    y := y + 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume true;
    assert !(x == 4 && y == 0);
    return;
}

