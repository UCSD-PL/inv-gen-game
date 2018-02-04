implementation main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var i: int;
  var i_old: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    assert (forall k: int :: 0 <= k && k < i ==> dst[k] == src[k]) && i >= 0;
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} src[i] != 0;
    dst[i] := src[i];
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} src[i] == 0;
    i_old := i;
    i := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    assert (forall k: int :: 0 <= k && k < i_old ==> dst[k] == src[k]) && src[i_old] == 0 && i <= i_old;
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} src[i] != 0;
    assert dst[i] == src[i];
    i := i + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} src[i] == 0;
    __RET := 0;
    return;
}

