implementation main()
{
  var i: int;
  var j: int;
  var k: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT >= 0;
    i := 0;
    k := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < LARGE_INT;
    havoc j;
    assume 1 <= j && j < LARGE_INT;
    i := i + j;
    k := k + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} LARGE_INT <= i;
    assert k <= LARGE_INT;
    return;
}

