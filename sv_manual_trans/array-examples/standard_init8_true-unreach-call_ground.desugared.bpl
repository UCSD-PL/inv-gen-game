implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon19_LoopHead;

  anon19_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 42);
    goto anon19_LoopDone, anon19_LoopBody;

  anon19_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon19_LoopHead;

  anon19_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon20_LoopHead;

  anon20_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 43);
    goto anon20_LoopDone, anon20_LoopBody;

  anon20_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 43;
    i := i + 1;
    goto anon20_LoopHead;

  anon20_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon21_LoopHead;

  anon21_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 44);
    goto anon21_LoopDone, anon21_LoopBody;

  anon21_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 44;
    i := i + 1;
    goto anon21_LoopHead;

  anon21_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon22_LoopHead;

  anon22_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 45);
    goto anon22_LoopDone, anon22_LoopBody;

  anon22_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 45;
    i := i + 1;
    goto anon22_LoopHead;

  anon22_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon23_LoopHead;

  anon23_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 46);
    goto anon23_LoopDone, anon23_LoopBody;

  anon23_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 46;
    i := i + 1;
    goto anon23_LoopHead;

  anon23_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon24_LoopHead;

  anon24_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 47);
    goto anon24_LoopDone, anon24_LoopBody;

  anon24_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 47;
    i := i + 1;
    goto anon24_LoopHead;

  anon24_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon25_LoopHead;

  anon25_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 48);
    goto anon25_LoopDone, anon25_LoopBody;

  anon25_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 48;
    i := i + 1;
    goto anon25_LoopHead;

  anon25_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon26_LoopHead;

  anon26_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 49);
    goto anon26_LoopDone, anon26_LoopBody;

  anon26_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 49;
    i := i + 1;
    goto anon26_LoopHead;

  anon26_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon27_LoopHead;

  anon27_LoopHead:
    assert true;
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 49;
    x := x + 1;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

