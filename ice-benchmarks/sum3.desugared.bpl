implementation main()
{
  var sn: int;
  var loop1: int;
  var n1: int;
  var x: int;


  anon0:
    assume loop1 >= 0 && n1 >= 0;
    sn := 0;
    x := 0;
    goto anon2_LoopHead;

  anon2_LoopHead:
    assert sn == x;
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} true;
    sn := sn + 1;
    x := x + 1;
    assert sn == x * 1 || sn == 0;
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} !true;
    return;
}

