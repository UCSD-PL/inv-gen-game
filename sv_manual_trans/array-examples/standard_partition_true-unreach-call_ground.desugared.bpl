implementation main() returns (__RET: int)
{
  var aa: [int]int;
  var a: int;
  var b: int;
  var c: int;
  var bb: [int]int;
  var cc: [int]int;
  var x: int;


  anon0:
    a := 0;
    b := 0;
    c := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert (forall k: int :: 0 <= k && k < b ==> bb[k] >= 0);
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} a < 100000;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} 0 > aa[a];
    goto anon3;

  anon3:
    a := a + 1;
    goto anon11_LoopHead;

  anon12_Then:
    assume {:partition} aa[a] >= 0;
    bb[b] := aa[a];
    b := b + 1;
    goto anon3;

  anon11_LoopDone:
    assume {:partition} 100000 <= a;
    a := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    assert (forall k: int :: 0 <= k && k < c ==> cc[k] < 0);
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} a < 100000;
    goto anon14_Then, anon14_Else;

  anon14_Else:
    assume {:partition} 0 <= aa[a];
    goto anon7;

  anon7:
    a := a + 1;
    goto anon13_LoopHead;

  anon14_Then:
    assume {:partition} aa[a] < 0;
    cc[c] := aa[a];
    c := c + 1;
    goto anon7;

  anon13_LoopDone:
    assume {:partition} 100000 <= a;
    x := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    assert true;
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} x < b;
    assert bb[x] >= 0;
    x := x + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} b <= x;
    __RET := 0;
    return;
}

