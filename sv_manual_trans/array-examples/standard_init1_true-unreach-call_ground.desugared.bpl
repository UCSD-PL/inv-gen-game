implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 42;
    x := x + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

