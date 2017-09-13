implementation main()
{
  var i: int;
  var LARGE_INT: int;


  anon0:
    i := 0;
    assume 0 <= LARGE_INT;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < LARGE_INT;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} LARGE_INT <= i;
    assert i == LARGE_INT;
    return;
}

