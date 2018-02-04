implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]bool;
  var i: int;
  var f: bool;


  anon0:
    i := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> (b[k] && a[k] >= 0) || (!b[k] && a[k] < 0));
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} i < 100000;
    goto anon13_Then, anon13_Else;

  anon13_Else:
    assume {:partition} 0 > a[i];
    b[i] := false;
    goto anon4;

  anon4:
    i := i + 1;
    goto anon12_LoopHead;

  anon13_Then:
    assume {:partition} a[i] >= 0;
    b[i] := true;
    goto anon4;

  anon12_LoopDone:
    assume {:partition} 100000 <= i;
    f := true;
    i := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> (b[k] && a[k] >= 0) || (!b[k] && a[k] < 0)) && f;
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < 100000;
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} !(a[i] >= 0 && !b[i]);
    goto anon8;

  anon8:
    goto anon16_Then, anon16_Else;

  anon16_Else:
    assume {:partition} !(a[i] < 0 && b[i]);
    goto anon10;

  anon10:
    i := i + 1;
    goto anon14_LoopHead;

  anon16_Then:
    assume {:partition} a[i] < 0 && b[i];
    f := false;
    goto anon10;

  anon15_Then:
    assume {:partition} a[i] >= 0 && !b[i];
    f := false;
    goto anon8;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    assert f;
    __RET := 0;
    return;
}

