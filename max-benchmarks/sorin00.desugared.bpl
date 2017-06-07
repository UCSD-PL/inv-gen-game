implementation main()
{
  var x: int;
  var y: int;
  var k: int;


  anon0:
    x := y mod k;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < k;
    x := y mod k;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} k <= x;
    assert x == y mod k;
    return;
}

