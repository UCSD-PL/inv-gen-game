implementation main()
{
  var d: int;
  var x: int;
  var y: int;


  anon0:
    d := 1;
    assume x <= 1000000 && x >= -1000000;
    goto anon19_Then, anon19_Else;

  anon19_Else:
    goto anon2;

  anon2:
    goto anon20_Then, anon20_Else;

  anon20_Else:
    goto anon8;

  anon8:
    goto anon23_Then, anon23_Else;

  anon23_Else:
    goto anon14;

  anon14:
    goto anon26_Then, anon26_Else;

  anon26_Else:
    goto anon16;

  anon16:
    goto anon27_LoopHead;

  anon27_LoopHead:
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} x > 0;
    x := x - d;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 0 >= x;
    assert x <= 0;
    return;

  anon26_Then:
    d := d - 1;
    goto anon16;

  anon23_Then:
    y := 0;
    goto anon24_Then, anon24_Else;

  anon24_Else:
    goto anon11;

  anon11:
    goto anon25_Then, anon25_Else;

  anon25_Else:
    y := y + 10;
    goto anon14;

  anon25_Then:
    y := y - 1;
    goto anon14;

  anon24_Then:
    y := y + 1;
    goto anon11;

  anon20_Then:
    y := 0;
    goto anon21_Then, anon21_Else;

  anon21_Else:
    goto anon5;

  anon5:
    goto anon22_Then, anon22_Else;

  anon22_Else:
    y := y + 10;
    goto anon8;

  anon22_Then:
    y := y - 1;
    goto anon8;

  anon21_Then:
    y := y + 1;
    goto anon5;

  anon19_Then:
    d := d - 1;
    goto anon2;
}

