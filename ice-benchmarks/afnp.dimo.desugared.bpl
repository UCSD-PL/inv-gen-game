implementation run()
{
  var x: int;
  var y: int;
  var flag: int;


  anon0:
    x := 1;
    y := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert (flag == 0 ==> y == 0) && (flag != 0 ==> x >= y);
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} y < 10 && flag != 0;
    x := x + y;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !(y < 10 && flag != 0);
    assert x >= y;
    return;
}

