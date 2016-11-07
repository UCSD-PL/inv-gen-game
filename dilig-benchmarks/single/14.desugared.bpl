implementation main()
{
  var a: int;
  var j: int;
  var m: int;


  anon0:
    a := 0;
    j := 1;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} 0 < m;
    goto anon9_LoopHead;

  anon9_LoopHead:
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} j <= m;
    goto anon10_Then, anon10_Else;

  anon10_Else:
    a := a - 1;
    goto anon6;

  anon6:
    j := j + 1;
    goto anon9_LoopHead;

  anon10_Then:
    a := a + 1;
    goto anon6;

  anon9_LoopDone:
    assume {:partition} m < j;
    assert a >= -m;
    assert a <= m;
    return;

  anon8_Then:
    assume {:partition} m <= 0;
    return;
}

