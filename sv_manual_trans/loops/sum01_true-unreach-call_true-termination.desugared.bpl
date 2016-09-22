implementation main()
{
  var i: int;
  var n: int;
  var sn: int;
  var a: int;


  anon0:
    a := 2;
    sn := 0;
    assume n < 1000 && n >= -1000;
    i := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i <= n;
    sn := sn + a;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n < i;
    assert sn == n * a || sn == 0;
    return;
}

