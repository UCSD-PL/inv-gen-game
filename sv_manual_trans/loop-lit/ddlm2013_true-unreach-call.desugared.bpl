implementation main()
{
  var i: int;
  var j: int;
  var a: int;
  var b: int;
  var flag: int;


  anon0:
    a := 0;
    b := 0;
    j := 1;
    assume flag != 0 ==> i == 0;
    assume flag == 0 ==> i == 1;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert flag != 0 ==> j == i + 1 && a == b && i mod 2 == 0;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume true;
    a := a + 1;
    b := b + j - i;
    i := i + 2;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} i mod 2 != 0;
    j := j + 1;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} i mod 2 == 0;
    j := j + 2;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume true;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} flag == 0;
    return;

  anon8_Then:
    assume {:partition} flag != 0;
    assert a == b;
    return;
}

