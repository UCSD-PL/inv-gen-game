implementation main()
{
  var i: int;
  var j: int;


  anon0:
    i := 1;
    j := 10;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j >= i;
    i := i + 2;
    j := -1 + j;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} i > j;
    assert j == 6;
    return;
}

