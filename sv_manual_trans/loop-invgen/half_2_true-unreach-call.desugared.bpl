implementation main()
{
  var n: int;
  var i: int;
  var j: int;
  var k: int;
  var LARGE_INT: int;


  anon0:
    assume n <= LARGE_INT;
    k := n;
    i := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    assert k + i div 2 == n && (n > 0 ==> i <= n + 1);
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} i < n;
    k := k - 1;
    i := i + 2;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} n <= i;
    j := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert n > 0 ==> k + j >= n div 2;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} j < n div 2;
    assert k > 0;
    k := k - 1;
    j := j + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} n div 2 <= j;
    return;
}

