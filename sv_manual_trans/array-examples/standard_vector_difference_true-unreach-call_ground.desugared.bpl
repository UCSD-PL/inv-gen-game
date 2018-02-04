implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var c: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> c[k] == a[k] - b[k]) && i <= 100000;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000;
    c[i] := a[i] - b[i];
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 <= k && k < 100000 ==> c[k] == a[k] - b[k]);
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < 100000;
    assert c[x] == a[x] - b[x];
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

