implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 1;
    a[0] := 7;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 < k && k < i ==> a[k] == a[k - 1] + 1) && i <= 100000;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000;
    a[i] := a[i - 1] + 1;
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100000 <= i;
    x := 1;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 < k && k < 100000 ==> a[k] >= a[k - 1] + 1);
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] >= a[x - 1];
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

