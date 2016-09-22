implementation main()
{
  var x: int;


  anon0:
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} true;
    assert x == 0;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !true;
    assert x == 0;
    return;
}

