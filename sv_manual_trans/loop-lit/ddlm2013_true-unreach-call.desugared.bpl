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
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} flag == 0;
    i := 1;
    goto anon3;

  anon3:
    goto anon10_LoopHead;

  anon10_LoopHead:
    assert flag != 0 ==> j == i + 1 && a == b && i mod 2 == 0;
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    a := a + 1;
    b := b + j - i;
    i := i + 2;
    goto anon11_Then, anon11_Else;

  anon11_Else:
    assume {:partition} i mod 2 != 0;
    j := j + 1;
    goto anon10_LoopHead;

  anon11_Then:
    assume {:partition} i mod 2 == 0;
    j := j + 2;
    goto anon10_LoopHead;

  anon10_LoopDone:
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} flag == 0;
    return;

  anon12_Then:
    assume {:partition} flag != 0;
    assert a == b;
    return;

  anon9_Then:
    assume {:partition} flag != 0;
    i := 0;
    goto anon3;
}

