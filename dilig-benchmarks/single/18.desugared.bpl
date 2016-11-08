implementation main()
{
  var flag: int;
  var b: int;
  var j: int;


  anon0:
    j := 0;
    b := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} b < 100;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} flag == 0;
    goto anon3;

  anon3:
    b := b + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} flag != 0;
    j := j + 1;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} 100 <= b;
    assert flag != 0 ==> j == 100;
    return;
}

