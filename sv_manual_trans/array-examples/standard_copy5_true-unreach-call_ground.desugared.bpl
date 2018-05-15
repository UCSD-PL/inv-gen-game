implementation main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var a5: [int]int;
  var a6: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} i < 100000;
    a2[i] := a1[i];
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
    a3[i] := a2[i];
    i := i + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon15_LoopHead;

  anon15_LoopHead:
    goto anon15_LoopDone, anon15_LoopBody;

  anon15_LoopBody:
    assume {:partition} i < 100000;
    a4[i] := a3[i];
    i := i + 1;
    goto anon15_LoopHead;

  anon15_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon16_LoopHead;

  anon16_LoopHead:
    goto anon16_LoopDone, anon16_LoopBody;

  anon16_LoopBody:
    assume {:partition} i < 100000;
    a5[i] := a4[i];
    i := i + 1;
    goto anon16_LoopHead;

  anon16_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon17_LoopHead;

  anon17_LoopHead:
    goto anon17_LoopDone, anon17_LoopBody;

  anon17_LoopBody:
    assume {:partition} i < 100000;
    a6[i] := a5[i];
    i := i + 1;
    goto anon17_LoopHead;

  anon17_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon18_LoopHead;

  anon18_LoopHead:
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} x < 100000;
    assert a1[x] == a6[x];
    x := x + 1;
    goto anon18_LoopHead;

  anon18_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

