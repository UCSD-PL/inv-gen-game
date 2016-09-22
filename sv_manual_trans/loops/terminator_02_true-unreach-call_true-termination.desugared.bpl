implementation main()
{
  var x: int;
  var z: int;


  anon0:
    assume x < 100;
    assume x > -100;
    assume z < 100;
    assume z > -100;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 100 && 100 < z;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    x := x - 1;
    z := z - 1;
    goto anon5_LoopHead;

  anon6_Then:
    x := x + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} !(x < 100 && 100 < z);
    assert x >= 100 || z <= 100;
    return;
}

