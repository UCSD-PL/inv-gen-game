implementation main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a1[k]) && i <= 100000;
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} i < 100000;
    a2[i] := a1[i];
    i := i + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon10_LoopHead;

  anon10_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a2[k] == a3[k]) && i <= 100000;
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} i < 100000;
    a3[i] := a2[i];
    i := i + 1;
    goto anon10_LoopHead;

  anon10_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a2[k]);
    assert (forall k: int :: 0 <= k && k < 100000 ==> a2[k] == a3[k]);
    assert (forall k: int :: 0 <= k && k < i ==> a3[k] == a4[k]) && i <= 100000;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < 100000;
    a4[i] := a3[i];
    i := i + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> a1[k] == a4[k]);
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} x < 100000;
    assert a1[x] == a4[x];
    x := x + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}
