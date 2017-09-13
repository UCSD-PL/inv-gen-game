implementation main()
{
  var n: int;
  var i: int;
  var sum: int;


  anon0:
    sum := 0;
    i := 0;
    assume n >= 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < n;
    sum := sum + i;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n <= i;
    assert sum >= 0;
    return;
}

