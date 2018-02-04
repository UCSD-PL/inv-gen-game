implementation main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> src[k] == dst[k]);
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} src[i] != 0;
    dst[i] := src[i];
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} src[i] == 0;
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> src[k] == dst[k]);
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < i;
    assert dst[x] == src[x];
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} i <= x;
    __RET := 0;
    return;
}

