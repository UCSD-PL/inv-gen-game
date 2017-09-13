implementation main()
{
  var x: int;
  var m: int;


  anon0:
    x := 100;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x > 0;
    havoc m;
    x := x - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 >= x;
    assert x == 0;
    return;
}

