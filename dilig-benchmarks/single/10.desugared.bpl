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
    assume true;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} w == 0;
    goto anon3;

  anon3:
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} z != 0;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} z == 0;
    y := y + 1;
    z := 1 - z;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} w != 0;
    x := x + 1;
    w := 1 - w;
    goto anon3;

  anon6_LoopDone:
    assume true;
    assert x == y;
    return;
}

