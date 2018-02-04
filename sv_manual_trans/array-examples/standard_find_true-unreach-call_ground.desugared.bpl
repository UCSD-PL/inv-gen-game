implementation main() returns (__RET: int)
{
  var a: [int]int;
  var e: int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] != e);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000 && a[i] != e;
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} !(i < 100000 && a[i] != e);
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert true;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < i;
    assert a[x] != e;
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} i <= x;
    __RET := 0;
    return;
}

