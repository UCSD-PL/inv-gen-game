implementation main()
{
  var x: int;


  anon0:
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x > 0;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    x := x - 1;
    goto anon5_LoopHead;

  anon6_Then:
    x := x - 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 0 >= x;
    assert x <= 0;
    return;
}

