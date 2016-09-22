implementation main()
{
  var i: int;
  var j: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 1000;
    i := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} LARGE_INT > i;
    i := i + 1;
    goto anon9_LoopHead;

  anon10_Then:
    assume {:partition} i >= LARGE_INT;
    goto anon4;

  anon4:
    assume i < 100;
    j := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert i < j + 100;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} LARGE_INT > i;
    i := i + 1;
    j := j + 1;
    goto anon11_LoopHead;

  anon12_Then:
    assume {:partition} i >= LARGE_INT;
    goto anon8;

  anon8:
    assume j < 100;
    assert i < 200;
    return;

  anon11_LoopDone:
    goto anon8;

  anon9_LoopDone:
    goto anon4;
}

