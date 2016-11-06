implementation main()
{
  var len: int;


  anon0:
    len := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} len != 4;
    goto anon3;

  anon3:
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} !(len < 0 || len >= 5);
    len := len + 1;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} len < 0 || len >= 5;
    assert false;
    return;

  anon7_Then:
    assume {:partition} len == 4;
    len := 0;
    goto anon3;

  anon6_LoopDone:
    return;
}

