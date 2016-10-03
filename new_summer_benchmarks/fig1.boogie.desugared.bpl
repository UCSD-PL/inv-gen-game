implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := -50;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 0;
    x := x + y;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 <= x;
    assert y > 0;
    return;
}

