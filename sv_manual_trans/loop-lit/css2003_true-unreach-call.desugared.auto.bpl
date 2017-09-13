implementation main()
{
  var LARGE_INT: int;
  var i: int;
  var j: int;
  var k: int;


  anon0:
    LARGE_INT := 1000;
    i := 1;
    j := 1;
    assume 0 <= k && k <= 1;
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} i < LARGE_INT;
    i := i + 1;
    j := j + k;
    k := k - 1;
    assert 1 <= i + k && i + k <= 2 && i >= 1;
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} LARGE_INT <= i;
    return;
}

