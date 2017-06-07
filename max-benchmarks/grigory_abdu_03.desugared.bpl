implementation main()
{
  var x: int;
  var y: int;
  var LEN: int;


  anon0:
    x := 0;
    y := 0;
    assume LEN >= 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < LEN;
    x := x + 1;
    y := y + 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} LEN <= x;
    assert y == 2 * x;
    assert x == LEN;
    assert x + y == 3 * LEN;
    return;
}

