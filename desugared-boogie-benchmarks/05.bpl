implementation main()
{
  var x: int;
  var y: int;
  var s: int;
  var j: int;


  anon0:
    s := 0;
    assume x >= 0;
    j := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} j < x;
    s := s + y;
    j := j + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} x <= j;
    assert s == x * y;
    return;
}
