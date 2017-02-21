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
    assert ((flag != 0) ==> a == b); 
    return;
}

