implementation main() returns (__RET: int)
{
  var aa: [int]int;
  var a: int;
  var x: int;


  anon0:
    a := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < a ==> aa[k] >= 0);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} aa[a] >= 0;
    a := a + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 0 > aa[a];
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 <= k && k < a ==> aa[k] >= 0);
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < a;
    assert aa[x] >= 0;
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} a <= x;
    __RET := 0;
    return;
}

