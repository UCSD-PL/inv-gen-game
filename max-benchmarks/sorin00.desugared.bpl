implementation main()
{
  var x: int;
  var y: int;
  var k: int;


  anon0:
    x := y mod k;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert x == y mod k;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < k && k > 1;
    y := y + 2;
    k := k - 1;
    x := y mod k;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !(x < k && k > 1);
    assert x == y mod k;
    return;
}

