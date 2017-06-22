implementation main()
{
  var i: int;
  var j: int;
  var k: int;


  anon0:
    j := 0;
    i := k * j;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j > 100;
    i := i - k;
    j := j - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 100 >= j;
    assert i == k * j;
    return;
}

