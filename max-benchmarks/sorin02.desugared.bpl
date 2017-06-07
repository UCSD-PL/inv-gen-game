implementation main()
{
  var n: int;
  var a: int;
  var su: int;
  var t: int;


  anon0:
    a := 1;
    su := 1;
    t := 1;
    assume n > 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} su <= n;
    t := t + 2;
    su := su + t;
    a := a + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n < su;
    assert a * a == su;
    return;
}

