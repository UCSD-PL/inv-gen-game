implementation main()
{
  var x: int;


  anon0:
    x := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 268435455;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} 65520 <= x;
    x := x + 2;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} x < 65520;
    x := x + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 268435455 <= x;
    assert 0 == x mod 2;
    return;
}

