implementation main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;


  anon0:
    i := 0;
    goto anon21_LoopHead;

  anon21_LoopHead:
    goto anon21_LoopDone, anon21_LoopBody;

  anon21_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 42;
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
    a[i] := 43;
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
    a[i] := 44;
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
    a[i] := 45;
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
    a[i] := 46;
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
    a[i] := 47;
    i := i + 1;
    goto anon26_LoopHead;

  anon26_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon27_LoopHead;

  anon27_LoopHead:
    goto anon27_LoopDone, anon27_LoopBody;

  anon27_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 48;
    i := i + 1;
    goto anon27_LoopHead;

  anon27_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon28_LoopHead;

  anon28_LoopHead:
    goto anon28_LoopDone, anon28_LoopBody;

  anon28_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 49;
    i := i + 1;
    goto anon28_LoopHead;

  anon28_LoopDone:
    assume {:partition} 100000 <= i;
    i := 0;
    goto anon29_LoopHead;

  anon29_LoopHead:
    goto anon29_LoopDone, anon29_LoopBody;

  anon29_LoopBody:
    assume {:partition} i < 100000;
    a[i] := 50;
    i := i + 1;
    goto anon29_LoopHead;

  anon29_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon30_LoopHead;

  anon30_LoopHead:
    goto anon30_LoopDone, anon30_LoopBody;

  anon30_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == 50;
    x := x + 1;
    goto anon30_LoopHead;

  anon30_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

