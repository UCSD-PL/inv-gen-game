implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 1;
    assume y > 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert x <= y;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < y;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} y div x <= x;
    x := x + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} x < y div x;
    x := x * x;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} y <= x;
    assert x == y;
    return;
}

