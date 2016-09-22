implementation main()
{
  var i: int;
  var x: int;
  var y: int;
  var n: int;


  anon0:
    i := 0;
    x := 0;
    y := 0;
    assume n > 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} true;
    assert x == 0;
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !true;
    assert x != 0;
    return;
}

