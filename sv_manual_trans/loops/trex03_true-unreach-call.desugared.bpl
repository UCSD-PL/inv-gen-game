implementation main()
{
  var x1: int;
  var x2: int;
  var x3: int;
  var d1: int;
  var d2: int;
  var d3: int;
  var c1: int;
  var c2: int;


  anon0:
    assume x1 >= 0 && x2 >= 0 && x3 >= 0;
    d1 := 1;
    d2 := 1;
    d3 := 1;
    goto anon18_Then, anon18_Else;

  anon18_Else:
    c1 := 1;
    goto anon3;

  anon3:
    goto anon19_Then, anon19_Else;

  anon19_Else:
    c2 := 1;
    goto anon6;

  anon6:
    goto anon20_LoopHead;

  anon20_LoopHead:
    assert x1 >= 0 && x2 >= 0 && x3 >= 0;
    goto anon20_LoopDone, anon20_LoopBody;

  anon20_LoopBody:
    assume {:partition} x1 > 0 && x2 > 0 && x3 > 0;
    goto anon21_Then, anon21_Else;

  anon21_Else:
    assume {:partition} c1 == 0;
    goto anon22_Then, anon22_Else;

  anon22_Else:
    assume {:partition} c2 == 0;
    x3 := x3 - d3;
    goto anon11;

  anon11:
    goto anon23_Then, anon23_Else;

  anon23_Else:
    c1 := 1;
    goto anon14;

  anon14:
    goto anon24_Then, anon24_Else;

  anon24_Else:
    c2 := 1;
    goto anon20_LoopHead;

  anon24_Then:
    c2 := 0;
    goto anon20_LoopHead;

  anon23_Then:
    c1 := 0;
    goto anon14;

  anon22_Then:
    assume {:partition} c2 != 0;
    x2 := x2 - d2;
    goto anon11;

  anon21_Then:
    assume {:partition} c1 != 0;
    x1 := x1 - d1;
    goto anon11;

  anon20_LoopDone:
    assume {:partition} !(x1 > 0 && x2 > 0 && x3 > 0);
    assert x1 == 0 || x2 == 0 || x3 == 0;
    return;

  anon19_Then:
    c2 := 0;
    goto anon6;

  anon18_Then:
    c1 := 0;
    goto anon3;
}

