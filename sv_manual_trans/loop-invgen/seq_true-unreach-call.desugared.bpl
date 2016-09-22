implementation main()
{
  var n0: int;
  var n1: int;
  var i0: int;
  var i1: int;
  var k: int;
  var j1: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 1000;
    assume -LARGE_INT <= n0 && n0 < LARGE_INT;
    assume -LARGE_INT <= n1 && n1 < LARGE_INT;
    i0 := 0;
    k := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert i0 == k && (n0 > 0 ==> i0 <= n0);
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i0 < n0;
    i0 := i0 + 1;
    k := k + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} n0 <= i0;
    i1 := 0;
    goto anon7_LoopHead;

  anon7_LoopHead:
    assert i0 + i1 == k && (n1 > 0 ==> i1 <= n1);
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} i1 < n1;
    i1 := i1 + 1;
    k := k + 1;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} n1 <= i1;
    j1 := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    assert j1 + k >= n0 + n1;
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} j1 < n0 + n1;
    assert k > 0;
    j1 := j1 + 1;
    k := k - 1;
    goto anon8_LoopHead;

  anon8_LoopDone:
    assume {:partition} n0 + n1 <= j1;
    return;
}

