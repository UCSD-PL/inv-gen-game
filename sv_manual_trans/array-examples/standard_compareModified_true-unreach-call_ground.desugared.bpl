implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var c: [int]int;
  var rv: bool;
  var x: int;


  anon0:
    i := 0;
    rv := true;
    goto anon10_LoopHead;

  anon10_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> c[k] == a[k]);
    assert rv ==> (forall k: int :: 0 <= k && k < i ==> a[k] == b[k]);
    assert i <= 100000;
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} i < 100000;
    goto anon11_Then, anon11_Else;

  anon11_Else:
    assume {:partition} a[i] == b[i];
    goto anon3;

  anon3:
    c[i] := a[i];
    i := i + 1;
    goto anon10_LoopHead;

  anon11_Then:
    assume {:partition} a[i] != b[i];
    rv := false;
    goto anon3;

  anon10_LoopDone:
    assume {:partition} 100000 <= i;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} !rv;
    goto anon7;

  anon7:
    x := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> c[k] == a[k]);
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == c[x];
    x := x + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;

  anon12_Then:
    assume {:partition} rv;
    x := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    assert rv ==> (forall k: int :: 0 <= k && k < 100000 ==> a[k] == b[k]);
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == b[x];
    x := x + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} 100000 <= x;
    goto anon7;
}

