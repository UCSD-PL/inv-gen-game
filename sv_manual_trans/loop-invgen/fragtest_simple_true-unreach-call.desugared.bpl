implementation main()
{
  var i: int;
  var j: int;
  var pvlen: int;
  var tmp___1: int;
  var k: int;
  var n: int;
  var LARGE_INT: int;


  anon0:
    k := 0;
    i := 0;
    assume LARGE_INT > 1000;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    goto anon14_Then, anon14_Else;

  anon14_Else:
    assume {:partition} i <= LARGE_INT;
    i := i + 1;
    goto anon13_LoopHead;

  anon14_Then:
    assume {:partition} !(i <= LARGE_INT);
    goto anon4;

  anon4:
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} pvlen >= i;
    goto anon6;

  anon6:
    i := 0;
    goto anon16_LoopHead;

  anon16_LoopHead:
    assert i == k;
    goto anon16_LoopDone, anon16_LoopBody;

  anon16_LoopBody:
    goto anon17_Then, anon17_Else;

  anon17_Else:
    assume {:partition} i <= LARGE_INT;
    tmp___1 := i;
    i := i + 1;
    k := k + 1;
    goto anon16_LoopHead;

  anon17_Then:
    assume {:partition} !(i <= LARGE_INT);
    goto anon10;

  anon10:
    j := 0;
    n := i;
    goto anon18_LoopHead;

  anon18_LoopHead:
    assert k + j == n && j <= n;
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} true;
    assert k >= 0;
    k := k - 1;
    i := i - 1;
    j := j + 1;
    goto anon19_Then, anon19_Else;

  anon19_Else:
    assume {:partition} n > j;
    goto anon18_LoopHead;

  anon19_Then:
    assume {:partition} j >= n;
    return;

  anon18_LoopDone:
    assume {:partition} !true;
    return;

  anon16_LoopDone:
    goto anon10;

  anon15_Then:
    assume {:partition} i > pvlen;
    pvlen := i;
    goto anon6;

  anon13_LoopDone:
    goto anon4;
}

