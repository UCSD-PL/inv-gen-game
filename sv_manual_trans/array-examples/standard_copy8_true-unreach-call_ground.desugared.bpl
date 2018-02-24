implementation main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var a5: [int]int;
  var a6: [int]int;
  var a7: [int]int;
  var a8: [int]int;
  var a9: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon19_LoopHead;

  anon19_LoopHead:
    goto anon19_LoopDone, anon19_LoopBody;

  anon19_LoopBody:
    assume {:partition} i < 100000;
    a2[i] := a1[i];
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
    a3[i] := a2[i];
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
    a4[i] := a3[i];
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
    a5[i] := a4[i];
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
    a6[i] := a5[i];
    i := i + 1;
    goto anon23_LoopHead;

  anon23_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon24_LoopHead;

  anon24_LoopHead:
    goto anon24_LoopDone, anon24_LoopBody;

  anon24_LoopBody:
    assume {:partition} i < 100000;
    a7[i] := a6[i];
    i := i + 1;
    goto anon24_LoopHead;

  anon24_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon25_LoopHead;

  anon25_LoopHead:
    goto anon25_LoopDone, anon25_LoopBody;

  anon25_LoopBody:
    assume {:partition} i < 100000;
    a8[i] := a7[i];
    i := i + 1;
    goto anon25_LoopHead;

  anon25_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon26_LoopHead;

  anon26_LoopHead:
    goto anon26_LoopDone, anon26_LoopBody;

  anon26_LoopBody:
    assume {:partition} i < 100000;
    a9[i] := a8[i];
    i := i + 1;
    goto anon26_LoopHead;

  anon26_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon27_LoopHead;

  anon27_LoopHead:
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} x < 100000;
    assert a1[x] == a9[x];
    x := x + 1;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

