implementation main()
{
  var x: int;
  var m: int;


  anon0:
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x < 100;
    havoc m;
    x := x + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 100 <= x;
    assert x == 100;
    return;
}

