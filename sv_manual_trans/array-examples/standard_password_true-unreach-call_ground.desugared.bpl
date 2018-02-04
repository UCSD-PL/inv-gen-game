implementation main() returns (__RET: int)
{
  var password: [int]int;
  var guess: [int]int;
  var i: int;
  var result: bool;
  var x: int;


  anon0:
    result := true;
    i := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    assert result ==> (forall k: int :: 0 <= k && k < i ==> password[k] == guess[k]);
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} i < 100000;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} password[i] == guess[i];
    goto anon3;

  anon3:
    i := i + 1;
    goto anon8_LoopHead;

  anon9_Then:
    assume {:partition} password[i] != guess[i];
    result := false;
    goto anon3;

  anon8_LoopDone:
    assume {:partition} 100000 <= i;
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} !result;
    goto anon7;

  anon7:
    __RET := 0;
    return;

  anon10_Then:
    assume {:partition} result;
    x := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert true;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} x < 100000;
    assert password[x] == guess[x];
    x := x + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} 100000 <= x;
    goto anon7;
}

