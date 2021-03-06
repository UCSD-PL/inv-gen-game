implementation main()
{
  var n: int;
  var x: int;
  var y: int;
  var i: int;


  anon0:
    x := 0;
    y := 0;
    i := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} i < n;
    i := i + 1;
    x := x + 1;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} i mod 2 != 0;
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} i mod 2 == 0;
    y := y + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} n <= i;
    assert i mod 2 == 0 ==> x == 2 * y;
    return;
}

