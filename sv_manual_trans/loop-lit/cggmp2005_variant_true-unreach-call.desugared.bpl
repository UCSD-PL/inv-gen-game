implementation main()
{
  var LARGE_INT: int;
  var lo: int;
  var mid: int;
  var hi: int;


  anon0:
    LARGE_INT := 1000;
    lo := 0;
    assume mid > 0 && mid <= LARGE_INT;
    hi := 2 * mid;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} mid > 0;
    lo := lo + 1;
    hi := hi - 1;
    mid := mid - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 >= mid;
    assert lo == hi;
    return;
}

