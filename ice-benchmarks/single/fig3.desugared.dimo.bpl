implementation main()
{
  var x: int;
  var y: int;
  var lock: int;
  var choice: int;


  anon0:
    assume choice == 0 ==> lock == 0 && y == x + 1;
    assume choice != 0 ==> lock == 1 && y == x;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume {:partition} x != y;
    lock := 1;
    x := y;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    goto anon4_LoopHead;

  anon5_Then:
    lock := 0;
    y := y + 1;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume {:partition} x == y;
    assert lock == 1;
    return;
}

