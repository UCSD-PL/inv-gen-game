implementation main()
{
  var i: int;
  var k: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 0;
    assume 0 < k && k <= 10;
    i := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < LARGE_INT * k;
    i := i + k;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} LARGE_INT * k <= i;
    assert i == LARGE_INT * k;
    return;
}

