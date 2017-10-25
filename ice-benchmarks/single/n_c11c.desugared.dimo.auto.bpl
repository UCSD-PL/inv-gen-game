implementation main()
{
  var len: int;
  var N: int;


  anon0:
    len := 0;
    assume N > 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume true;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} len != N;
    goto anon3;

  anon3:
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} !(len < 0 || len >= N + 1);
    len := len + 1;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} len < 0 || len >= N + 1;
    assert false;
    return;

  anon7_Then:
    assume {:partition} len == N;
    len := 0;
    goto anon3;

  anon6_LoopDone:
    assume true;
    return;
}

