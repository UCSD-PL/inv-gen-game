implementation main()
{
  var d: int;
  var x: int;


  anon0:
    d := 1;
    assume x <= 1000000 && x >= -1000000;
    assume d == 1 || d == 0 || d == -1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert true;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x > 0;
    x := x - d;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 >= x;
    assert x <= 0;
    return;
}

