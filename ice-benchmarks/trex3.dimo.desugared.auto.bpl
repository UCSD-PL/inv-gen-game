implementation main()
{
  var d1: int;
  var d2: int;
  var d3: int;
  var x1: int;
  var x2: int;
  var x3: int;
  var c1: int;
  var c2: int;


  anon0:
    assume d1 >= 0 && d2 >= 0 && d3 >= 0;
    assume x1 >= 0 && x2 >= 0 && x3 >= 0;
    d1 := 1;
    d2 := 1;
    d3 := 1;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x1 > 0 && x2 > 0 && x3 > 0;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} c1 == 0;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} c2 == 0;
    x3 := x3 - d3;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} c2 != 0;
    x2 := x2 - d2;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} c1 != 0;
    x1 := x1 - d1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} !(x1 > 0 && x2 > 0 && x3 > 0);
    assert x1 == 0 || x2 == 0 || x3 == 0;
    return;
}

