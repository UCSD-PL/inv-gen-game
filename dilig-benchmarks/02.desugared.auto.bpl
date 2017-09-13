implementation run(k0: int)
{
  var i: int;
  var j: int;
  var z: int;
  var x: int;
  var y: int;
  var w: int;
  var k: int;


  anon0:
    i := 1;
    j := 0;
    z := i - j;
    x := 0;
    y := 0;
    w := 0;
    k := k0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} k > 0;
    z := z + x + y + w;
    y := y + 1;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} z - (z div 2) * 2 != 1;
    goto anon3;

  anon3:
    w := w + 2;
    k := k - 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} z - (z div 2) * 2 == 1;
    x := x + 1;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} 0 >= k;
    assert x == y;
    return;
}

