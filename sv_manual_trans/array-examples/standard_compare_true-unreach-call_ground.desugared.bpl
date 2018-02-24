implementation main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var rv: bool;
  var x: int;


  anon0:
    i := 0;
    rv := true;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} i < 100000;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} a[i] == b[i];
    goto anon3;

  anon3:
    i := i + 1;
    goto anon8_LoopHead;

  anon9_Then:
    assume {:partition} a[i] != b[i];
    rv := false;
    goto anon3;

  anon8_LoopDone:
    assume {:partition} 100000 <= i;
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} !rv;
    goto anon7;

  anon7:
    __RET := 0;
    return;

  anon10_Then:
    assume {:partition} rv;
    x := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} x < 100000;
    assert a[x] == b[x];
    x := x + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= x;
    goto anon7;
}

