implementation main()
{
  var x: int;


  anon0:
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 268435455;
    x := x + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 268435455 <= x;
    assert x >= 268435455;
    return;
}

