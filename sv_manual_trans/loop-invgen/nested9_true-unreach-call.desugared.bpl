implementation main()
{
  var i: int;
  var j: int;
  var k: int;
  var n: int;
  var l: int;
  var m: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 1000;
    assume -LARGE_INT < n && n < LARGE_INT;
    assume -LARGE_INT < m && m < LARGE_INT;
    assume -LARGE_INT < l && l < LARGE_INT;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} m + l < 3 * n;
    return;

  anon7_Then:
    assume {:partition} 3 * n <= m + l;
    i := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} i < n;
    j := 2 * i;
    goto anon9_LoopHead;

  anon9_LoopHead:
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} j < 3;
    k := i;
    goto anon10_LoopHead;

  anon10_LoopHead:
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} k < j;
    assert k - i <= 2 * n;
    k := k + 1;
    goto anon10_LoopHead;

  anon10_LoopDone:
    assume {:partition} j <= k;
    j := j + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 3 <= j;
    i := i + 1;
    goto anon8_LoopHead;

  anon8_LoopDone:
    assume {:partition} n <= i;
    return;
}

