implementation main()
{
  var n: int;
  var i: int;
  var j: int;
  var k: int;


  anon0:
    i := 0;
    k := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} i < n;
    i := i + 1;
    k := k + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} n <= i;
    j := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} j < n;
    assert k > 0;
    j := j + 1;
    k := k - 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} n <= j;
    return;
}

