implementation main()
{
  var i: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 0 && LARGE_INT mod 2 == 0;
    i := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert i <= LARGE_INT && i mod 2 == 0;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < LARGE_INT;
    i := i + 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} LARGE_INT <= i;
    assert i == LARGE_INT;
    return;
}

