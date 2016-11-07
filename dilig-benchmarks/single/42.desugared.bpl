implementation main()
{
  var flag: int;
  var x: int;
  var y: int;
  var a: int;


  anon0:
    x := 1;
    y := 1;
    goto anon13_Then, anon13_Else;

  anon13_Else:
    assume {:partition} flag == 0;
    a := 1;
    goto anon3;

  anon3:
    goto anon14_LoopHead;

  anon14_LoopHead:
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} flag == 0;
    a := x + y + 1;
    y := y + 1;
    goto anon7;

  anon7:
    goto anon16_Then, anon16_Else;

  anon16_Else:
    assume {:partition} a mod 2 != 1;
    x := x + 1;
    goto anon14_LoopHead;

  anon16_Then:
    assume {:partition} a mod 2 == 1;
    y := y + 1;
    goto anon14_LoopHead;

  anon15_Then:
    assume {:partition} flag != 0;
    a := x + y;
    x := x + 1;
    goto anon7;

  anon14_LoopDone:
    goto anon17_Then, anon17_Else;

  anon17_Else:
    assume {:partition} flag == 0;
    goto anon12;

  anon12:
    assert a mod 2 == 1;
    return;

  anon17_Then:
    assume {:partition} flag != 0;
    a := a + 1;
    goto anon12;

  anon13_Then:
    assume {:partition} flag != 0;
    a := 0;
    goto anon3;
}

