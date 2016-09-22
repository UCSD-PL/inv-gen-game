implementation main()
{
  var d: int;
  var LARGE_INT: int;
  var x: int;
  var y: int;
  var k: int;
  var z: int;


  anon0:
    LARGE_INT := 1000000;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    d := 2;
    goto anon3;

  anon3:
    z := 1;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} z < k;
    z := 2 * z;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} k <= z;
    assert z >= 1;
    assume x <= LARGE_INT && x >= -LARGE_INT;
    assume y <= LARGE_INT && y >= -LARGE_INT;
    assume k <= LARGE_INT && k >= -LARGE_INT;
    goto anon14_LoopHead;

  anon14_LoopHead:
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} x > 0 && y > 0;
    goto anon15_Then, anon15_Else;

  anon15_Else:
    y := y - d;
    goto anon14_LoopHead;

  anon15_Then:
    x := x - d;
    goto anon16_Then, anon16_Else;

  anon16_Else:
    y := 1;
    goto anon10;

  anon10:
    z := z - 1;
    goto anon14_LoopHead;

  anon16_Then:
    y := 0;
    goto anon10;

  anon14_LoopDone:
    assume {:partition} !(x > 0 && y > 0);
    return;

  anon12_Then:
    d := 1;
    goto anon3;
}

