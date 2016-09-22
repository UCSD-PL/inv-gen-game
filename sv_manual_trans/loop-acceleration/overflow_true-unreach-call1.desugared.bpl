implementation main()
{
  var x: int;


  anon0:
    x := 10;
    goto anon4_LoopHead;

  anon4_LoopHead:
    assert x mod 2 == 0;
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} x >= 10;
    x := x + 2;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} x != 4294967296;
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} x == 4294967296;
    x := 0;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} 10 > x;
    assert x mod 2 == 0;
    return;
}

