implementation run(n: int, m: int)
{
  var x: int;
  var y: int;


  anon0:
    assume n >= 0;
    assume m >= 0;
    assume m < n;
    x := 0;
    y := m;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} x < n;
    x := x + 1;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} m >= x;
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} x > m;
    y := y + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} n <= x;
    assert y == n;
    return;
}

