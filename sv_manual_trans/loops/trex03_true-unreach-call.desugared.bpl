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
    assume c1 == 0 || c1 == 1;
    assume c2 == 0 || c2 == 1;
    goto anon12_LoopHead;

  anon12_LoopHead:
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} x1 > 0 && x2 > 0 && x3 > 0;
    goto anon13_Then, anon13_Else;

  anon13_Else:
    assume {:partition} c1 == 0;
    goto anon14_Then, anon14_Else;

  anon14_Else:
    assume {:partition} c2 == 0;
    x3 := x3 - d3;
    goto anon5;

  anon5:
    goto anon15_Then, anon15_Else;

  anon15_Else:
    c1 := 1;
    goto anon8;

  anon8:
    goto anon16_Then, anon16_Else;

  anon16_Else:
    c2 := 1;
    goto anon12_LoopHead;

  anon16_Then:
    c2 := 0;
    goto anon12_LoopHead;

  anon15_Then:
    c1 := 0;
    goto anon8;

  anon14_Then:
    assume {:partition} c2 != 0;
    x2 := x2 - d2;
    goto anon5;

  anon13_Then:
    assume {:partition} c1 != 0;
    x1 := x1 - d1;
    goto anon5;

  anon12_LoopDone:
    assume {:partition} !(x1 > 0 && x2 > 0 && x3 > 0);
    assert x1 == 0 || x2 == 0 || x3 == 0;
    return;
}

