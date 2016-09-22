implementation main()
{
  var i: int;
  var k: int;
  var n: int;
  var l: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 1000;
    assume l > 0;
    assume l < LARGE_INT;
    assume n < LARGE_INT;
    k := 1;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} k < n;
    i := 1;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i < n;
    assert 1 <= i;
    i := i + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} n <= i;
    k := k + 1;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    goto anon5_LoopHead;

  anon7_Then:
    l := l + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} n <= k;
    return;
}

