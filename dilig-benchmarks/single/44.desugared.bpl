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
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} flag != 1;
    n := 2;
    goto anon3;

  anon3:
    i := 0;
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} i <= k;
    i := i + 1;
    j := j + n;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} k < i;
    assert flag == 1 ==> j == i;
    return;

  anon6_Then:
    assume {:partition} flag == 1;
    n := 1;
    goto anon3;
}

