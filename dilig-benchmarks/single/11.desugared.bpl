implementation main()
{
  var j: int;
  var i: int;
  var x: int;


  anon0:
    j := 0;
    x := 100;
    i := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert j == 2 * i && i <= x;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < x;
    j := j + 2;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} x <= i;
    assert j == 2 * x;
    return;
}

