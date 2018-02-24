implementation main() returns (__RET: int)
{
  var aa: [int]int;
  var a: int;
  var b: int;
  var c: int;
  var bb: [int]int;
  var cc: [int]int;
  var x: int;


  anon0:
    a := 0;
    b := 0;
    c := 0;
    goto anon10_LoopHead;

  anon10_LoopHead:
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} a < 100000;
    goto anon11_Then, anon11_Else;

  anon11_Else:
    assume {:partition} 0 > aa[a];
    cc[c] := aa[a];
    c := c + 1;
    goto anon4;

  anon4:
    a := a + 1;
    goto anon10_LoopHead;

  anon11_Then:
    assume {:partition} aa[a] >= 0;
    bb[b] := aa[a];
    b := b + 1;
    goto anon4;

  anon10_LoopDone:
    assume {:partition} 100000 <= a;
    x := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} x < b;
    assert bb[x] >= 0;
    x := x + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} b <= x;
    x := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} x < c;
    assert cc[x] < 0;
    x := x + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} c <= x;
    __RET := 0;
    return;
}

