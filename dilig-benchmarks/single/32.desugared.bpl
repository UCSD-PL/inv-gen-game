implementation main()
{
  var k: int;
  var b: int;
  var i: int;
  var j: int;
  var n: int;


  anon0:
    k := 100;
    i := j;
    n := 0;
    assume b == 0 || b == 1;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} n < 2 * k;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} b != 1;
    j := j + 1;
    goto anon4;

  anon4:
    b := 1 - b;
    n := n + 1;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} b == 1;
    i := i + 1;
    goto anon4;

  anon6_LoopDone:
    assume {:partition} 2 * k <= n;
    assert i == j;
    return;
}

