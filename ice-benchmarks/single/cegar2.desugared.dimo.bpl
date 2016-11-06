implementation main()
{
  var N: int;
  var x: int;
  var m: int;
  var input: int;


  anon0:
    x := 0;
    m := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < N;
    havoc input;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} input == 0;
    goto anon3;

  anon3:
    x := x + 1;
    goto anon5_LoopHead;

  anon6_Then:
    assume {:partition} input != 0;
    m := x;
    goto anon3;

  anon5_LoopDone:
    assume {:partition} N <= x;
    assert N > 0 ==> 0 <= m && m < N;
    return;
}

