implementation main()
{
  var i: int;
  var j: int;
  var k: int;
  var n: int;
  var LARGE_INT: int;


  anon0:
    assume n < LARGE_INT;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} k != n;
    return;

  anon9_Then:
    assume {:partition} k == n;
    i := 0;
    goto anon10_LoopHead;

  anon10_LoopHead:
    assert n > 0 ==> i <= n && k == n;
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} i < n;
    j := 2 * i;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert j >= 2 * i && k == n;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} j < n;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assert k >= n;
    assert k <= n;
    goto anon7;

  anon7:
    j := j + 1;
    goto anon11_LoopHead;

  anon12_Then:
    k := j;
    goto anon13_LoopHead;

  anon13_LoopHead:
    assert k >= j && k <= n;
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} k < n;
    assert k >= 2 * i;
    k := k + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} n <= k;
    goto anon7;

  anon11_LoopDone:
    assume {:partition} n <= j;
    i := i + 1;
    goto anon10_LoopHead;

  anon10_LoopDone:
    assume {:partition} n <= i;
    return;
}

