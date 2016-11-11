implementation main()
{
  var x: int;
  var y: int;


  anon0:
    x := 0;
    y := 50;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 100;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} 50 <= x;
    x := x + 1;
    y := y + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} x < 50;
    x := x + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100 <= x;
    assert y == 100;
    return;
}

