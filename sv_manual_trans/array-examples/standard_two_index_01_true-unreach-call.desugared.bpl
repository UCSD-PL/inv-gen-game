implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var j: int;


  anon0:
    i := 0;
    j := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> a[k] == b[k]) && i == j;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 10000;
    a[j] := b[i];
    i := i + 1;
    j := j + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 10000 <= i;
    i := 0;
    j := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 <= k && k < 10000 ==> a[k] == b[k]) && i == j;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i < 10000;
    assert a[j] == b[j];
    i := i + 1;
    j := j + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 10000 <= i;
    __RET := 0;
    return;
}

