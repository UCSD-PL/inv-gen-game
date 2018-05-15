implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon17_LoopHead;

  anon17_LoopHead:
    goto anon17_LoopDone, anon17_LoopBody;

  anon17_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
    i := i + 1;
    goto anon17_LoopHead;

  anon17_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon18_LoopHead;

  anon18_LoopHead:
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 43;
    i := i + 1;
    goto anon18_LoopHead;

  anon18_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon19_LoopHead;

  anon19_LoopHead:
    goto anon19_LoopDone, anon19_LoopBody;

  anon19_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 44;
    i := i + 1;
    goto anon19_LoopHead;

  anon19_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon20_LoopHead;

  anon20_LoopHead:
    goto anon20_LoopDone, anon20_LoopBody;

  anon20_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 45;
    i := i + 1;
    goto anon20_LoopHead;

  anon20_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon21_LoopHead;

  anon21_LoopHead:
    goto anon21_LoopDone, anon21_LoopBody;

  anon21_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 46;
    i := i + 1;
    goto anon21_LoopHead;

  anon21_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon22_LoopHead;

  anon22_LoopHead:
    goto anon22_LoopDone, anon22_LoopBody;

  anon22_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 47;
    i := i + 1;
    goto anon22_LoopHead;

  anon22_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon23_LoopHead;

  anon23_LoopHead:
    goto anon23_LoopDone, anon23_LoopBody;

  anon23_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 48;
    i := i + 1;
    goto anon23_LoopHead;

  anon23_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon24_LoopHead;

  anon24_LoopHead:
    goto anon24_LoopDone, anon24_LoopBody;

  anon24_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 48;
    x := x + 1;
    goto anon24_LoopHead;

  anon24_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

