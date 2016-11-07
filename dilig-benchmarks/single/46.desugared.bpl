implementation main()
{
  var w: int;
  var z: int;
  var x: int;
  var y: int;


  anon0:
    w := 1;
    z := 0;
    x := 0;
    y := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} w mod 2 != 1;
    goto anon3;

  anon3:
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} z mod 2 != 0;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} z mod 2 == 0;
    y := y + 1;
    z := z + 1;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} w mod 2 == 1;
    x := x + 1;
    w := w + 1;
    goto anon3;

  anon6_LoopDone:
    assert x <= 1;
    return;
}

