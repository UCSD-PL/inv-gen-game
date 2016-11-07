implementation run(flag: bool)
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
    assert x == y && (flag ==> j == x + i) && (!flag ==> j == i);
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    x := x + 1;
    y := y + 1;
    i := i + x;
    j := j + y;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} !flag;
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} flag;
    j := j + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assert j >= i;
    return;
}

