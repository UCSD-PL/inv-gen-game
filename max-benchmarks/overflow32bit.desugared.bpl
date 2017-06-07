implementation main()
{
  var i: bv8;
  var j: int;


  anon0:
    i := 0bv8;
    j := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} bv8sge(i, 0bv8);
    i := bv8add(i, 1bv8);
    j := j + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !bv8sge(i, 0bv8);
    assert bv8sgt(i, 0bv8);
    assert j > 0;
    return;
}

