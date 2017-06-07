implementation gcd(a0: int, b0: int) returns (r: int)
{
  var t: int;
  var a: int;
  var b: int;
  var cd: int;


  anon0:
    a := a0;
    b := b0;
    t := 0;
    assume a > 0 && b > 0 && a > b;
    assume cd >= 1 && cd <= a0 && cd <= b0 && a0 mod cd == 0 && b0 mod cd == 0;
    assume cd >= 1 && cd <= a && cd <= b && a mod cd == 0 && b mod cd == 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} b > 0;
    t := a mod b;
    a := b;
    b := t;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} 0 >= b;
    r := a;
    assert a0 mod r == 0 && b0 mod r == 0;
    return;
}

