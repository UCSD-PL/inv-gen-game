implementation main()
{
  var i: int;
  var j: int;


  anon0:
    i := 1;
    j := 10;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert i - j <= 3 && i - j >= -9 && i + j >= 11 && i + j <= 21 && i >= 1 && j <= 10 && j >= 5 && i <= 12 && i - int(i / 2) * 2 == 1 && i * j >= 10 && (j >= i ==> j >= 6);
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j >= i;
    i := i + 2;
    j := j - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} i > j;
    assert j == 6;
    return;
}

