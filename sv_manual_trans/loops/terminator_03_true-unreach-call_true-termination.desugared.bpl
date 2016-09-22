implementation main()
{
  var x: int;
  var y: int;
  var LIMIT: int;


  anon0:
    LIMIT := 1000000;
    assume y <= LIMIT;
    goto anon4_Then, anon4_Else;

  anon4_Else:
    assume {:partition} 0 >= y;
    goto anon3;

  anon3:
    assert y <= 0 || (y > 0 && x >= 100);
    return;

  anon4_Then:
    assume {:partition} y > 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} x < 100;
    x := x + y;
    goto anon5_LoopHead;

  anon5_LoopDone:
    assume {:partition} 100 <= x;
    goto anon3;
}

