implementation main()
{
  var x: int;
  var y: int;
  var i: int;
  var t: int;


  anon0:
    i := 0;
    t := y;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} x != y;
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} 0 >= x;
    goto anon7_LoopHead;

  anon8_Then:
    assume {:partition} x > 0;
    y := y + x;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assert y >= t;
    return;

  anon6_Then:
    assume {:partition} x == y;
    return;
}

