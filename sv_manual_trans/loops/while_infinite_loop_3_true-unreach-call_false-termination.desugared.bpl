implementation main()
{
  var x: int;


  anon0:
    x := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} true;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} true;
    x := 0;
    goto anon3;

  anon3:
    assert x == 0;
    goto anon5_LoopHead;

  anon6_LoopDone:
    assume {:partition} !true;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} !true;
    assert x != 0;
    return;
}

