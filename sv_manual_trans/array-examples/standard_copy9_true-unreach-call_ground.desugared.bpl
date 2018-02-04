implementation main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var a5: [int]int;
  var a6: [int]int;
  var a7: [int]int;
  var a8: [int]int;
  var a9: [int]int;
  var a0: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon21_LoopHead;

  anon21_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a1[k]) && i <= 100000;
    goto anon21_LoopDone, anon21_LoopBody;

  anon21_LoopBody:
    assume {:partition} i < 100000;
    a2[i] := a1[i];
    i := i + 1;
    goto anon21_LoopHead;

  anon21_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon22_LoopHead;

  anon22_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a3[k]) && i <= 100000;
    goto anon22_LoopDone, anon22_LoopBody;

  anon22_LoopBody:
    assume {:partition} i < 100000;
    a3[i] := a2[i];
    i := i + 1;
    goto anon22_LoopHead;

  anon22_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon23_LoopHead;

  anon23_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a3[k] == a4[k]) && i <= 100000;
    goto anon23_LoopDone, anon23_LoopBody;

  anon23_LoopBody:
    assume {:partition} i < 100000;
    a4[i] := a3[i];
    i := i + 1;
    goto anon23_LoopHead;

  anon23_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon24_LoopHead;

  anon24_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a5[k] == a4[k]) && i <= 100000;
    goto anon24_LoopDone, anon24_LoopBody;

  anon24_LoopBody:
    assume {:partition} i < 100000;
    a5[i] := a4[i];
    i := i + 1;
    goto anon24_LoopHead;

  anon24_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon25_LoopHead;

  anon25_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a5[k] == a6[k]) && i <= 100000;
    goto anon25_LoopDone, anon25_LoopBody;

  anon25_LoopBody:
    assume {:partition} i < 100000;
    a6[i] := a5[i];
    i := i + 1;
    goto anon25_LoopHead;

  anon25_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon26_LoopHead;

  anon26_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a7[k] == a6[k]) && i <= 100000;
    goto anon26_LoopDone, anon26_LoopBody;

  anon26_LoopBody:
    assume {:partition} i < 100000;
    a7[i] := a6[i];
    i := i + 1;
    goto anon26_LoopHead;

  anon26_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon27_LoopHead;

  anon27_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a7[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a7[k] == a8[k]) && i <= 100000;
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} i < 100000;
    a8[i] := a7[i];
    i := i + 1;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon28_LoopHead;

  anon28_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a7[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a7[k] == a8[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a9[k] == a8[k]) && i <= 100000;
    goto anon28_LoopDone, anon28_LoopBody;

  anon28_LoopBody:
    assume {:partition} i < 100000;
    a9[i] := a8[i];
    i := i + 1;
    goto anon28_LoopHead;

  anon28_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon29_LoopHead;

  anon29_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a3[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a4[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a5[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a7[k] == a6[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a7[k] == a8[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a8[k] == a9[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a9[k] == a0[k]) && i <= 100000;
    goto anon29_LoopDone, anon29_LoopBody;

  anon29_LoopBody:
    assume {:partition} i < 100000;
    a0[i] := a9[i];
    i := i + 1;
    goto anon29_LoopHead;

  anon29_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon30_LoopHead;

  anon30_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a0[k]);
    goto anon30_LoopDone, anon30_LoopBody;

  anon30_LoopBody:
    assume {:partition} x < 100000;
    assert a1[x] == a0[x];
    x := x + 1;
    goto anon30_LoopHead;

  anon30_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

