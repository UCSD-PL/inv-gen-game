implementation main()
{
  var x: int;
  var n: int;


  anon0:
    assume n >= 0;
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < n;
    x := x + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n <= x;
    assert x == n;
    return;
}

