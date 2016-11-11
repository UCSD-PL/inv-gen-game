implementation main()
{
  var x: int;
  var y: int;
  var z: int;


  anon0:
    x := 1;
    y := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} y < 1000 && z == 1;
    havoc z;
    x := x + y;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !(y < 1000 && z == 1);
    assert x >= y;
    return;
}

