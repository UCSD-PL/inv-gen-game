implementation main()
{
  var x: int;
  var N: int;


  anon0:
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < N;
    x := x + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} N <= x;
    assert N < 0 || x == N;
    return;
}

