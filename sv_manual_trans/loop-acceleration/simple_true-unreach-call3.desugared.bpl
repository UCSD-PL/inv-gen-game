implementation main()
{
  var x: int;
  var N: int;


  anon0:
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert x mod 2 == 0;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < N;
    x := x + 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} N <= x;
    assert x mod 2 == 0;
    return;
}

