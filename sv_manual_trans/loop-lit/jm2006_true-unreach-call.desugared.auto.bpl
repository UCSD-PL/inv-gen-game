implementation main()
{
  var i: int;
  var j: int;
  var x: int;
  var y: int;


  anon0:
    assume i >= 0 && j >= 0;
    x := i;
    y := j;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} x != 0;
    x := x - 1;
    y := y - 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} x == 0;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} i != j;
    return;

  anon5_Then:
    assume {:partition} i == j;
    assert y == 0;
    return;
}

