implementation main()
{
  var i: int;
  var sn: int;
  var SIZE: int;
  var a: int;


  anon0:
    assume SIZE >= 0;
    sn := 0;
    i := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert sn == a * (i - 1) && i <= SIZE + 1;
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i <= SIZE;
    sn := sn + a;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} SIZE < i;
    assert sn == SIZE * a || sn == 0;
    return;
}

