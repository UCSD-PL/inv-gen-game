implementation main()
{
  var x: int;
  var y: int;
  var lock: int;


  anon0:
    lock := 0;
    lock := 1;
    x := y;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    goto anon2;

  anon2:
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} x != y;
    lock := 1;
    x := y;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    goto anon7_LoopHead;

  anon8_Then:
    lock := 0;
    y := y + 1;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} x == y;
    assert lock == 1;
    return;

  anon6_Then:
    lock := 0;
    y := y + 1;
    goto anon2;
}

