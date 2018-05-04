implementation main()
{
  var n: int;
  var a: int;
  var su: int;
  var t: int;


  anon0:
    assume (n>0);
    a := 0;
    su := 1;
    t := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} su <= n;
    a := a + 1;
    t := t + 2;
    su := su + t;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n < su;
    assert (a + 1) * (a + 1) == su;
    return;
}

