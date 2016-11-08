implementation main()
{
  var n: int;
  var x: int;


  anon0:
    n := 0;
    x := 0;
    goto anon3_LoopHead;

  anon3_LoopHead:
    goto anon3_LoopDone, anon3_LoopBody;

  anon3_LoopBody:
    assume true;
    n := n + 1;
    x := x + 2 * n - 1;
    goto anon3_LoopHead;

  anon3_LoopDone:
    assume true;
    assert x == n * n;
    return;
}

