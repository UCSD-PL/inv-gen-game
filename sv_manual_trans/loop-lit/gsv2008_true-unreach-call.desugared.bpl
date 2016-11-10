implementation main()
{
  var LARGE_INT: int;
  var x: int;
  var y: int;


  anon0:
    LARGE_INT := 1000;
    x := -50;
    assume -1000 < y && y < LARGE_INT;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert y <= 0 ==> x < 0;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 0;
    x := x + y;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 <= x;
    assert y > 0;
    return;
}

