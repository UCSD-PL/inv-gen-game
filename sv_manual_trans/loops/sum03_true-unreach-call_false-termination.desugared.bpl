implementation main()
{
  var sn: int;
  var x: int;
  var a: int;


  anon0:
    sn := 0;
    x := 0;
    a := 2;
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} x < 1000000;
    sn := sn + a;
    x := x + 1;
    assert sn == x * a || sn == 0;
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} 1000000 <= x;
    return;
}

