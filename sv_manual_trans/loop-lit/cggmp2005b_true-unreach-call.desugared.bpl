implementation main()
{
  var i: int;
  var j: int;
  var k: int;


  anon0:
    i := 0;
    k := 9;
    j := -100;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i <= 100;
    i := i + 1;
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} j < 20;
    j := i + j;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} 20 <= j;
    k := 4;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} k <= 3;
    k := k + 1;
    goto anon8_LoopHead;

  anon8_LoopDone:
    assume {:partition} 3 < k;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100 < i;
    assert k == 4;
    return;
}

