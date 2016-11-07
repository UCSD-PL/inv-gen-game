implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    goto anon9_Then, anon9_Else;

  anon9_Else:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    goto anon8_LoopHead;

  anon10_Then:
    goto anon11_Then, anon11_Else;

  anon11_Else:
    assume {:partition} 4 > x;
    goto anon5;

  anon5:
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} 0 <= x;
    goto anon8_LoopHead;

  anon12_Then:
    assume {:partition} x < 0;
    y := y - 1;
    goto anon8_LoopHead;

  anon11_Then:
    assume {:partition} x >= 4;
    x := x + 1;
    y := y + 1;
    goto anon5;

  anon9_Then:
    x := x + 1;
    y := y + 100;
    goto anon8_LoopHead;

  anon8_LoopDone:
    assert x < 4 || y > 2;
    return;
}

