implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    goto anon32_LoopHead;

  anon32_LoopHead:
    assert (y mod 2 == 0 ==> x mod 2 == 0) && (y mod 2 == 1 ==> x <= 0);
    goto anon32_LoopDone, anon32_LoopBody;

  anon32_LoopBody:
    assume {:partition} x < 99;
    goto anon33_Then, anon33_Else;

  anon33_Else:
    assume {:partition} y mod 2 != 0;
    x := x + 1;
    goto anon4;

  anon4:
    goto anon34_Then, anon34_Else;

  anon34_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 2;
    goto anon7;

  anon7:
    goto anon35_Then, anon35_Else;

  anon35_Else:
    assume {:partition} y mod 2 != 0;
    x := x + 2;
    goto anon10;

  anon10:
    goto anon36_Then, anon36_Else;

  anon36_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 2;
    goto anon13;

  anon13:
    goto anon37_Then, anon37_Else;

  anon37_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 2;
    goto anon16;

  anon16:
    goto anon38_Then, anon38_Else;

  anon38_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 4;
    goto anon19;

  anon19:
    goto anon39_Then, anon39_Else;

  anon39_Else:
    assume {:partition} y mod 2 != 0;
    x := x + 4;
    goto anon22;

  anon22:
    goto anon40_Then, anon40_Else;

  anon40_Else:
    assume {:partition} y mod 2 != 0;
    x := x + 2;
    goto anon25;

  anon25:
    goto anon41_Then, anon41_Else;

  anon41_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 4;
    goto anon28;

  anon28:
    goto anon42_Then, anon42_Else;

  anon42_Else:
    assume {:partition} y mod 2 != 0;
    x := x - 4;
    goto anon32_LoopHead;

  anon42_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon32_LoopHead;

  anon41_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon28;

  anon40_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon25;

  anon39_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon22;

  anon38_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon19;

  anon37_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon16;

  anon36_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon13;

  anon35_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon10;

  anon34_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon7;

  anon33_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon4;

  anon32_LoopDone:
    assume {:partition} 99 <= x;
    assert x mod 2 == y mod 2;
    return;
}

