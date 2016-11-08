implementation run(flag: int)
{
  var x: int;
  var y: int;
  var i: int;
  var j: int;


  anon0:
    x := 0;
    y := 0;
    j := 0;
    i := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume true;
    x := x + 1;
    y := y + 1;
    i := i + x;
    j := j + y;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} flag != 0;
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} flag == 0;
    j := j + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume true;
    assert j >= i;
    return;
}

