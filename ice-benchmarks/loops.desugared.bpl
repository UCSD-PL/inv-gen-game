implementation main()
{
  var x: int;
  var s: int;
  var y: int;


  anon0:
    assume x >= 0;
    s := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert s <= x;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} s < x;
    s := s + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} x <= s;
    y := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert y <= x;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} y < s;
    y := y + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} s <= y;
    assert y == x;
    return;
}

