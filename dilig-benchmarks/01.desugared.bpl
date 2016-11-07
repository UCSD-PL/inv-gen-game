implementation run()
{
  var x: int;
  var y: int;
  var t1: int;
  var t2: int;
  var count: int;
  var n: int;


  anon0:
    x := 1;
    y := 1;
    count := n;
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} count > 0;
    t1 := x;
    t2 := y;
    x := t1 + t2;
    y := t1 + t2;
    count := count - 1;
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} 0 >= count;
    return;
}

