implementation main()
{
  var flag: int;
  var j: int;
  var k: int;


  anon0:
    j := 2;
    k := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume true;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} flag == 0;
    j := j + 2;
    k := k + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} flag != 0;
    j := j + 4;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume true;
    assert k != 0 ==> j == 2 * k + 2;
    return;
}

