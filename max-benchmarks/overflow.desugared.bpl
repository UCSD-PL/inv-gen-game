implementation main()
{
  var i: int;
  var j: int;


  anon0:
    i := 0;
    j := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i >= 0;
    i := i + 1;
    j := j + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 > i;
    assert i > 0;
    assert j > 0;
    return;
}

