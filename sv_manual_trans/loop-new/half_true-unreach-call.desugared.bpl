implementation main()
{
  var i: int;
  var n: int;
  var k: int;
  var LARGE_INT: int;


  anon0:
    i := 0;
    n := 0;
    assume k <= LARGE_INT && k >= -LARGE_INT;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (i mod 2 == 0 ==> 2 * n == i) && (i mod 2 == 1 ==> 2 * n - 1 == i) && (k >= 0 ==> i <= 2 * k);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 2 * k;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} i mod 2 != 0;
    goto anon3;

  anon3:
    i := i + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} i mod 2 == 0;
    n := n + 1;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} 2 * k <= i;
    assert k < 0 || n == k;
    return;
}

