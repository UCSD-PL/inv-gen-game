implementation main(a: [int]int, size: int)
{
  var d: int;
  var i: int;
  var b: [int]int;


  anon0:
    d := a[0];
    i := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    assert (forall k: int :: 0 <= k && k < i - 1 ==> b[k] >= 0);
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} i < size;
    b[i - 1] := a[i] - d;
    d := a[i];
    i := i + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} size <= i;
    assert (forall k: int :: 0 <= k && k < size - 1 ==> b[k] >= 0);
    return;
}

