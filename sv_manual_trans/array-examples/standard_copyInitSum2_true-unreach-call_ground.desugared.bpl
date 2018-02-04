implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == 42) && i <= 100000;
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon10_LoopHead;

  anon10_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == b[k]) && i <= 100000;
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} i < 100000;
    b[i] := a[i];
    i := i + 1;
    goto anon10_LoopHead;

  anon10_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert (forall k: int :: i <= k && k < 100000 ==> b[k] == a[k]) && i <= 100000;
    assert (forall k: int :: 0 <= k && k < i ==> b[k] == a[k] + k) && i <= 100000;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < 100000;
    b[i] := b[i] + i;
    i := i + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a[k] == 42);
    assert (forall k: int :: 0 <= k && k < i ==> b[k] == a[k] + k) && i <= 100000;
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} x < 100000;
    assert b[x] == 42 + x;
    x := x + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

