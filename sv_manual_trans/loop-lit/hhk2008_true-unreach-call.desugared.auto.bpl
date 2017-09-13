implementation main()
{
  var a: int;
  var b: int;
  var res: int;
  var cnt: int;


  anon0:
    assume a <= 1000000;
    assume 0 <= b && b <= 1000000;
    res := a;
    cnt := b;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} cnt > 0;
    cnt := cnt - 1;
    res := res + 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 >= cnt;
    assert res == a + b;
    return;
}

