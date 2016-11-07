implementation main()
{
  var flag: int;
  var b: int;
  var j: int;


  anon0:
    j := 0;
    b := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} b < 100;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} flag == 0;
    goto anon3;

  anon3:
    b := b + 1;
    goto anon6_LoopHead;

  anon7_Then:
    assume {:partition} flag != 0;
    j := j + 1;
    goto anon3;

  anon6_LoopDone:
    assume {:partition} 100 <= b;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} flag == 0;
    return;

  anon8_Then:
    assume {:partition} flag != 0;
    assert j == 100;
    return;
}

