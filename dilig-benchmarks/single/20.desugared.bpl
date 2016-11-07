implementation main()
{
  var x: int;
  var y: int;
  var k: int;
  var j: int;
  var i: int;
  var n: int;
  var m: int;


  anon0:
    assume x + y == k;
    m := 0;
    j := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} j < n;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} j != i;
    y := y + 1;
    x := x - 1;
    goto anon4;

  anon4:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    goto anon6;

  anon6:
    j := j + 1;
    goto anon8_LoopHead;

  anon10_Then:
    m := j;
    goto anon6;

  anon9_Then:
    assume {:partition} j == i;
    x := x + 1;
    y := y - 1;
    goto anon4;

  anon8_LoopDone:
    assume {:partition} n <= j;
    assert x + y == k;
    assert n > 0 ==> 0 <= m;
    assert n > 0 ==> m < n;
    return;
}

