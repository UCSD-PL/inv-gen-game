implementation main()
{
  var n: int;
  var flag: int;
  var k: int;
  var i: int;
  var j: int;
  var z: int;


  anon0:
    assume n >= 0;
    k := 1;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} flag == 0;
    goto anon2;

  anon2:
    i := 0;
    j := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i <= n;
    i := i + 1;
    j := j + i;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} n < i;
    z := k + i + j;
    assert z > 2 * n;
    return;

  anon5_Then:
    assume {:partition} flag != 0;
    havoc k;
    assume k >= 0;
    goto anon2;
}

