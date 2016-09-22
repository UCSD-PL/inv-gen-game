implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert x <= 6;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 6;
    x := x + 1;
    y := y * 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 6 <= x;
    assert x == 6;
    return;
}

