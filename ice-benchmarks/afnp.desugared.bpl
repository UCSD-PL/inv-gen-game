implementation run(flag: bool)
{
  var x: int;
  var y: int;


  anon0:
    x := 1;
    y := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert (!flag ==> y == 0) && (flag ==> x >= y);
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} y < 10 && flag;
    x := x + y;
    y := y + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !(y < 10 && flag);
    assert x >= y;
    return;
}

