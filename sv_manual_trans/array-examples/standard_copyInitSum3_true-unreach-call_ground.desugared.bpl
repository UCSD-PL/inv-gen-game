implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 42);
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == b[k]);
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} i < 100000;
    b[i] := a[i];
    i := i + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    assert (forall k: int :: i <= k && k < 100000 ==> a[k] == b[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a[k] + k == b[k]);
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} i < 100000;
    b[i] := b[i] + i;
    i := i + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    assert (forall k: int :: i <= k && k < 100000 ==> a[k] + k == b[k]);
    assert (forall k: int :: 0 <= k && k < i ==> k == b[k]);
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < 100000;
    b[i] := b[i] - a[i];
    i := i + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> k == b[k]);
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} x < 100000;
    assert b[x] == x;
    x := x + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

