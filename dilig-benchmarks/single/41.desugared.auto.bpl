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
    assume flag != 0 ==> k >= 0;
    assume flag == 0 ==> k == 1;
    i := 0;
    j := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i <= n;
    i := i + 1;
    j := j + i;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} n < i;
    z := k + i + j;
    assert z > 2 * n;
    return;
}

