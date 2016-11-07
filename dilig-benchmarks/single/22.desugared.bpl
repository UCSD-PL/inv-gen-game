implementation main()
{
  var x: int;
  var y: int;
  var z: int;
  var k: int;


  anon0:
    x := 0;
    y := 0;
    z := 0;
    k := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} k mod 3 != 0;
    goto anon3;

  anon3:
    y := y + 1;
    z := z + 1;
    k := x + y + z;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} k mod 3 == 0;
    x := x + 1;
    goto anon3;

  anon5_LoopDone:
    assert x == y;
    assert y == z;
    return;
}

