implementation main()
{
  var i: int;
  var sn: int;


  anon0:
    sn := 0;
    i := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i <= 8;
    sn := sn + 1;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 8 < i;
    assert sn == 8 || sn == 0;
    return;
}

