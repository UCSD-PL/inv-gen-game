implementation main()
{
  var x: int;
  var m: int;
  var n: int;


  anon0:
    x := 0;
    m := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < n;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    goto anon3;

  anon3:
    x := x + 1;
    goto anon5_LoopHead;

  anon6_Then:
    m := x;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} n <= x;
    assert m >= 0 || n <= 0;
    assert m < n || n <= 0;
    return;
}

