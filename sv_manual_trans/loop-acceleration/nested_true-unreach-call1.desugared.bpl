implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert x <= 268435455;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 268435455;
    y := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} y < 10;
    y := y + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 10 <= y;
    x := x + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 268435455 <= x;
    assert x mod 2 == 1;
    return;
}

