implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    assert (x < 50 ==> x == y) && (x >= 50 ==> x - 50 == 50 - y) && y >= 0;
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} true;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} 50 <= x;
    y := y - 1;
    goto anon4;

  anon4:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} 0 <= y;
    x := x + 1;
    goto anon8_LoopHead;

  anon10_Then:
    assume {:partition} y < 0;
    goto anon7;

  anon7:
    assert x == 100;
    return;

  anon9_Then:
    assume {:partition} x < 50;
    y := y + 1;
    goto anon4;

  anon8_LoopDone:
    assume {:partition} !true;
    goto anon7;
}

