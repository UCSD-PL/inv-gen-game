implementation main()
{
  var LARGE_INT: int;
  var i: int;
  var n: int;
  var a: int;
  var b: int;


  anon0:
    LARGE_INT := 1000;
    i := 0;
    a := 0;
    b := 0;
    assume n >= 0 && n <= LARGE_INT;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i < n;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    a := a + 2;
    b := b + 1;
    goto anon4;

  anon4:
    i := i + 1;
    goto anon6_LoopHead;

  anon7_Then:
    a := a + 1;
    b := b + 2;
    goto anon4;

  anon6_LoopDone:
    assume {:partition} n <= i;
    assert a + b == 3 * n;
    return;
}

