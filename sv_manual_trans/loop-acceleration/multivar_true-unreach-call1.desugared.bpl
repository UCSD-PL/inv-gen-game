implementation main()
{
  var x: int;
  var y: int;


  anon0:
    y := x;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert x == y;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 1024;
    x := x + 1;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 1024 <= x;
    assert x == y;
    return;
}

