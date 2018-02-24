implementation main() returns (__RET: int)
{
  var a: [int]int;
  var swapped: bool;
  var x: int;
  var y: int;
  var i: int;
  var t: int;


  anon0:
    swapped := true;
    goto anon10_LoopHead;

  anon10_LoopHead:
    goto anon10_LoopDone, anon10_LoopBody;

  anon10_LoopBody:
    assume {:partition} swapped;
    swapped := false;
    i := 1;
    goto anon11_LoopHead;

  anon11_LoopHead:
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < 100000;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} a[i] >= a[i - 1];
    goto anon4;

  anon4:
    i := i + 1;
    goto anon11_LoopHead;

  anon12_Then:
    assume {:partition} a[i - 1] > a[i];
    t := a[i];
    a[i] := a[i - 1];
    a[i - 1] := t;
    swapped := true;
    goto anon4;

  anon11_LoopDone:
    assume {:partition} 100000 <= i;
    goto anon10_LoopHead;

  anon10_LoopDone:
    assume {:partition} !swapped;
    x := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} x < 100000;
    y := x + 1;
    goto anon14_LoopHead;

  anon14_LoopHead:
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} y < 100000;
    assert a[x] <= a[y];
    y := y + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} 100000 <= y;
    x := x + 1;
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

