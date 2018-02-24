implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 43;
    i := i + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 44;
    i := i + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 45;
    i := i + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 45;
    x := x + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

