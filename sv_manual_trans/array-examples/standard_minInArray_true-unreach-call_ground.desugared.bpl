implementation main() returns (__RET: int)
{
  var a: [int]int;
  var min: int;
  var i: int;
  var x: int;


  anon0:
    min := 0;
    i := 0;
    goto anon7_LoopHead;

  anon7_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> min <= a[k]);
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} i < 100000;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} min <= a[i];
    goto anon3;

  anon3:
    i := i + 1;
    goto anon7_LoopHead;

  anon8_Then:
    assume {:partition} a[i] < min;
    min := a[i];
    goto anon3;

  anon7_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    assert true;
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] >= min;
    x := x + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

