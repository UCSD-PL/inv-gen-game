implementation main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var a5: [int]int;
  var a6: [int]int;
  var a7: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a1[k]) && i <= 100000;
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} i < 100000;
    a2[i] := a1[i];
    i := i + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon16_LoopHead;

  anon16_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a3[k]) && i <= 100000;
    goto anon16_LoopDone, anon16_LoopBody;

  anon16_LoopBody:
    assume {:partition} i < 100000;
    a3[i] := a2[i];
    i := i + 1;
    goto anon16_LoopHead;

  anon16_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon17_LoopHead;

  anon17_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a3[k] == a4[k]) && i <= 100000;
    goto anon17_LoopDone, anon17_LoopBody;

  anon17_LoopBody:
    assume {:partition} i < 100000;
    a4[i] := a3[i];
    i := i + 1;
    goto anon17_LoopHead;

  anon17_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon18_LoopHead;

  anon18_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a5[k] == a4[k]) && i <= 100000;
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} i < 100000;
    a5[i] := a4[i];
    i := i + 1;
    goto anon18_LoopHead;

  anon18_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon19_LoopHead;

  anon19_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a5[k] == a6[k]) && i <= 100000;
    goto anon19_LoopDone, anon19_LoopBody;

  anon19_LoopBody:
    assume {:partition} i < 100000;
    a6[i] := a5[i];
    i := i + 1;
    goto anon19_LoopHead;

  anon19_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon20_LoopHead;

  anon20_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a7[k] == a6[k]) && i <= 100000;
    goto anon20_LoopDone, anon20_LoopBody;

  anon20_LoopBody:
    assume {:partition} i < 100000;
    a7[i] := a6[i];
    i := i + 1;
    goto anon20_LoopHead;

  anon20_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon21_LoopHead;

  anon21_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a7[k]);
    goto anon21_LoopDone, anon21_LoopBody;

  anon21_LoopBody:
    assume {:partition} x < 100000;
    assert a1[x] == a7[x];
    x := x + 1;
    goto anon21_LoopHead;

  anon21_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

