implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 42);
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 43);
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 43;
    i := i + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 44);
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 44;
    i := i + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon16_LoopHead;

  anon16_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 45);
    goto anon16_LoopDone, anon16_LoopBody;

  anon16_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 45;
    i := i + 1;
    goto anon16_LoopHead;

  anon16_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon17_LoopHead;

  anon17_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 46);
    goto anon17_LoopDone, anon17_LoopBody;

  anon17_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 46;
    i := i + 1;
    goto anon17_LoopHead;

  anon17_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon18_LoopHead;

  anon18_LoopHead:
    assert true;
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 46;
    x := x + 1;
    goto anon18_LoopHead;

  anon18_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

