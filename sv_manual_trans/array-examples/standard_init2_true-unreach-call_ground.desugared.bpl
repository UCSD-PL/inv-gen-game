implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon7_LoopHead;

  anon7_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 42);
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 43);
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 43;
    i := i + 1;
    goto anon8_LoopHead;

  anon8_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    assert true;
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 43;
    x := x + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

