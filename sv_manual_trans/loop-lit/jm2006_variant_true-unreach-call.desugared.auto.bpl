implementation main()
{
  var i: int;
  var j: int;
  var LARGE_INT: int;
  var x: int;
  var y: int;
  var z: int;


  anon0:
    LARGE_INT := 1000;
    assume i >= 0 && i <= LARGE_INT;
    assume j >= 0;
    x := i;
    y := j;
    z := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} x != 0;
    x := x - 1;
    y := y - 2;
    z := z + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} x == 0;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} i != j;
    return;

  anon5_Then:
    assume {:partition} i == j;
    assert y == -z;
    return;
}

