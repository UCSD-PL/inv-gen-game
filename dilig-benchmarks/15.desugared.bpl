implementation run(n: int)
{
  var j: int;
  var k: int;


  anon0:
    assume n > 0;
    assume k > n;
    j := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j < n;
    j := j + 1;
    k := k - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n <= j;
    assert k >= 0;
    return;
}

