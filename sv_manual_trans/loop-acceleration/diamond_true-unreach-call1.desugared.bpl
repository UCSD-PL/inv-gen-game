implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (y mod 2 == 0 ==> x mod 2 == y mod 2) && (y mod 2 == 1 ==> x <= 99);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 99;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} y mod 2 != 0;
    x := x + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} y mod 2 == 0;
    x := x + 2;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 99 <= x;
    assert x mod 2 == y mod 2;
    return;
}

