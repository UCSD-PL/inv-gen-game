implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} y >= 0;
    y := y + x;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 > y;
    assert 0 == 1;
    return;
}

