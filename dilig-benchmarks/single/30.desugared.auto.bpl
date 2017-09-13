implementation main()
{
  var i: int;
  var c: int;


  anon0:
    i := 0;
    c := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < 1000;
    c := c + i;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 1000 <= i;
    assert c >= 0;
    return;
}

