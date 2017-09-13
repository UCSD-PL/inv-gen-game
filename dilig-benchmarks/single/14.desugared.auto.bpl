implementation main()
{
  var a: int;
  var j: int;
  var m: int;


  anon0:
    a := 0;
    j := 1;
    assume m > 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} j <= m;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    a := a - 1;
    goto anon4;

  anon4:
    j := j + 1;
    goto anon6_LoopHead;

  anon7_Then:
    a := a + 1;
    goto anon4;

  anon6_LoopDone:
    assume {:partition} m < j;
    assert a >= -m;
    assert a <= m;
    return;
}

