implementation main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var largest1: int;
  var largest2: int;
  var temp: int;
  var x: int;


  anon0:
    largest1 := array[0];
    largest2 := array[1];
    goto anon13_Then, anon13_Else;

  anon13_Else:
    assume {:partition} largest2 <= largest1;
    goto anon2;

  anon2:
    i := 2;
    goto anon14_LoopHead;

  anon14_LoopHead:
    //assert (forall k: int :: 0 <= k && k < i ==> largest2 >= array[k] || largest1 == array[k]) && largest1 >= largest2;
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < 100000;
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} largest1 > array[i];
    goto anon16_Then, anon16_Else;

  anon16_Else:
    assume {:partition} largest2 >= array[i];
    goto anon7;

  anon7:
    i := i + 1;
    goto anon14_LoopHead;

  anon16_Then:
    assume {:partition} array[i] > largest2;
    largest2 := array[i];
    goto anon7;

  anon15_Then:
    assume {:partition} array[i] >= largest1;
    largest2 := largest1;
    largest1 := array[i];
    goto anon7;

  anon14_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon17_LoopHead;

  anon17_LoopHead:
    //assert (forall k: int :: 0 <= k && k < 10000 ==> largest2 >= array[k] || largest1 == array[k]) && largest1 >= largest2;
    goto anon17_LoopDone, anon17_LoopBody;

  anon17_LoopBody:
    assume {:partition} x < 100000;
    assert array[x] <= largest1;
    x := x + 1;
    goto anon17_LoopHead;

  anon17_LoopDone:
    assume {:partition} 100000 <= x;
    x := 0;
    goto anon18_LoopHead;

  anon18_LoopHead:
    //assert (forall k: int :: 0 <= k && k < 10000 ==> largest2 >= array[k] || largest1 == array[k]) && largest1 >= largest2;
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} x < 100000;
    assert array[x] <= largest2 || array[x] == largest1;
    x := x + 1;
    goto anon18_LoopHead;

  anon18_LoopDone:
    assume {:partition} 100000 <= x;
    __RET := 0;
    return;

  anon13_Then:
    assume {:partition} largest1 < largest2;
    temp := largest1;
    largest1 := largest2;
    largest2 := temp;
    goto anon2;
}

