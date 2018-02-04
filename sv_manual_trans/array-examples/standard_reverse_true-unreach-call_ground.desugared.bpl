implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> b[k] == a[100000 - k - 1]);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000;
    b[i] := a[100000 - i - 1];
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert true;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == b[100000 - x - 1];
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

