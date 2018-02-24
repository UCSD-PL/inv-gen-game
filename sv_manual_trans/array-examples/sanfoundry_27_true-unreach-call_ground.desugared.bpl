implementation main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var largest: int;
  var x: int;


  anon0:
    largest := array[0];
    i := 1;
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} i < 100000;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} array[i] <= largest;
    goto anon3;

  anon3:
    i := i + 1;
    goto anon7_LoopHead;

  anon8_Then:
    assume {:partition} largest < array[i];
    largest := array[i];
    goto anon3;

  anon7_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} x < 100000;
    assert largest >= array[x];
    x := x + 1;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;
}

