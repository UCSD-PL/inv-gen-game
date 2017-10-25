implementation main()
{
  var c1: int;
  var c2: int;
  var n: int;
  var v: int;
  var i: int;
  var k: int;


  anon0:
    c1 := 4000;
    c2 := 2000;
    assume n > 0;
    assume n < 10;
    k := 0;
    i := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} i < n;
    i := i + 1;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    v := 1;
    goto anon4;

  anon4:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} v != 0;
    k := k + c2;
    goto anon8_LoopHead;

  anon10_Then:
    assume {:partition} v == 0;
    k := k + c1;
    goto anon8_LoopHead;

  anon9_Then:
    v := 0;
    goto anon4;

  anon8_LoopDone:
    assume {:partition} n <= i;
    assert k > n;
    return;
}

