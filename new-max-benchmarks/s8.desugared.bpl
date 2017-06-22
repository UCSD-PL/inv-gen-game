implementation main()
{
  var i: int;
  var j: int;
  var z: int;


  anon0:
    j := 0;
    i := 0;
    z := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j < 1000;
    i := i + 5;
    j := j + 1;
    z := 5 * j;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 1000 <= j;
    assert i == z;
    return;
}

