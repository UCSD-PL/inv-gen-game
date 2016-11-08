implementation main()
{
  var k: int;
  var flag: int;
  var i: int;
  var j: int;
  var n: int;


  anon0:
    i := 0;
    j := 0;
    assume flag == 1 ==> n == 1;
    assume flag != 1 ==> n == 2;
    i := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i <= k;
    i := i + 1;
    j := j + n;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} k < i;
    assert flag == 1 ==> j == i;
    return;
}

