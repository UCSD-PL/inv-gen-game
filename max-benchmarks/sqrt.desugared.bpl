implementation sqrt()
{
  var n: int;
  var x0: int;
  var x1: int;
  var q: int;


  anon0:
    assume n > 0;
    x0 := n;
    x1 := 1;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume {:partition} (x1 - x0) * (x1 - x0) >= 1 && x1 != x0 + 1;
    x0 := x1;
    q := n div x0;
    x1 := (x0 + q) div 2;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume {:partition} !((x1 - x0) * (x1 - x0) >= 1 && x1 != x0 + 1);
    assert x0 * x0 <= n;
    assert (x0 + 1) * (x0 + 1) > n;
    return;
}

