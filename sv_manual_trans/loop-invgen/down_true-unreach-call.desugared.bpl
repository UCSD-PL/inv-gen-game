implementation main()
{
  var n: int;
  var i: int;
  var j: int;
  var k: int;


  anon0:
    k := 0;
    i := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    assert n >= 0 ==> i <= n && i == k;
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} i < n;
    i := i + 1;
    k := k + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} n <= i;
    j := n;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert j >= 0 ==> j == k;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} j > 0;
    assert k > 0;
    j := j - 1;
    k := k - 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 0 >= j;
    return;
}

