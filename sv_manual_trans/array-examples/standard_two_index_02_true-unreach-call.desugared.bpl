implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var j: int;


  anon0:
    i := 1;
    j := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000;
    a[j] := b[i];
    i := i + 2;
    j := j + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100000 <= i;
    i := 1;
    j := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} i < 100000;
    assert a[j] == b[2 * j + 1];
    i := i + 2;
    j := j + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100000 <= i;
    __RET := 0;
    return;
}

