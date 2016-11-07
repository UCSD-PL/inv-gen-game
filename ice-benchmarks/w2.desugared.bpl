implementation main()
{
  var x: int;
  var n: int;


  anon0:
    assume n > 0;
    x := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert x < n;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} 0 == 0;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    goto anon5_LoopHead;

  anon6_Then:
    x := x + 1;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} n > x;
    goto anon5_LoopHead;

  anon7_Then:
    assume {:partition} x >= n;
    goto anon4;

  anon4:
    assert x == n;
    return;

  anon5_LoopDone:
    assume {:partition} 0 != 0;
    goto anon4;
}

