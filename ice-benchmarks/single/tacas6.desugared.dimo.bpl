implementation main()
{
  var x: int;
  var y: int;
  var i: int;
  var j: int;


  anon0:
    x := i;
    y := j;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} x != 0;
    x := x - 1;
    y := y - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} x == 0;
    assert i == j ==> y == 0;
    return;
}

