implementation main()
{
  var i: int;
  var j: int;
  var k: int;
  var l: int;


  anon0:
    assume k >= 0;
    j := 0;
    i := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j < k;
    i := i + l * k;
    j := j + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} k <= j;
    assert i == k * j * l;
    return;
}

