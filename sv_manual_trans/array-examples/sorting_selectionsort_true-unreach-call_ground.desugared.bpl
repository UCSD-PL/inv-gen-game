implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;
  var y: int;
  var s: int;
  var k: int;
  var tmp: int;


  anon0:
    i := 0;
    goto anon19_LoopHead;

  anon19_LoopHead:
    assert (forall l: int, m: int :: 0 <= l && l < i && l < m && m < 100000 ==> a[l] <= a[m]);
    goto anon19_LoopDone, anon19_LoopBody;

  anon19_LoopBody:
    assume {:partition} i < 100000;
    k := i + 1;
    s := i;
    goto anon20_LoopHead;

  anon20_LoopHead:
    assert (forall l: int :: i <= l && l < k ==> a[s] <= a[l]) && i <= s && i < k;
    goto anon20_LoopDone, anon20_LoopBody;

  anon20_LoopBody:
    assume {:partition} k < 100000;
    goto anon21_Then, anon21_Else;

  anon21_Else:
    assume {:partition} a[s] <= a[k];
    goto anon4;

  anon4:
    k := k + 1;
    goto anon20_LoopHead;

  anon21_Then:
    assume {:partition} a[k] < a[s];
    s := k;
    goto anon4;

  anon20_LoopDone:
    assume {:partition} 100000 <= k;
    goto anon22_Then, anon22_Else;

  anon22_Else:
    assume {:partition} s == i;
    goto anon7;

  anon7:
    x := 0;
    goto anon23_LoopHead;

  anon23_LoopHead:
    assert true;
    goto anon23_LoopDone, anon23_LoopBody;

  anon23_LoopBody:
    assume {:partition} x < i;
    y := x + 1;
    goto anon24_LoopHead;

  anon24_LoopHead:
    assert x < y;
    goto anon24_LoopDone, anon24_LoopBody;

  anon24_LoopBody:
    assume {:partition} y < i;
    assert a[x] <= a[y];
    y := y + 1;
    goto anon24_LoopHead;

  anon24_LoopDone:
    assume {:partition} i <= y;
    x := x + 1;
    goto anon23_LoopHead;

  anon23_LoopDone:
    assume {:partition} i <= x;
    x := i;
    goto anon25_LoopHead;

  anon25_LoopHead:
    assert x >= i;
    goto anon25_LoopDone, anon25_LoopBody;

  anon25_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] >= a[i];
    x := x + 1;
    goto anon25_LoopHead;

  anon25_LoopDone:
    assume {:partition} 100000 <= x;
    i := i + 1;
    goto anon19_LoopHead;

  anon22_Then:
    assume {:partition} s != i;
    tmp := a[s];
    a[s] := a[i];
    a[i] := tmp;
    goto anon7;

  anon19_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon26_LoopHead;

  anon26_LoopHead:
    assert true;
    goto anon26_LoopDone, anon26_LoopBody;

  anon26_LoopBody:
    assume {:partition} x < 100000;
    y := x + 1;
    goto anon27_LoopHead;

  anon27_LoopHead:
    assert y > x;
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} y < 100000;
    assert a[x] <= a[y];
    y := y + 1;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 100000 <= y;
    x := x + 1;
    goto anon26_LoopHead;

  anon26_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

