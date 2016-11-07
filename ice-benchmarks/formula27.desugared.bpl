implementation main()
{
  var x1: int;
  var x2: int;
  var x3: int;
  var x4: int;
  var x5: int;
  var x1p: int;
  var x2p: int;
  var x3p: int;
  var x4p: int;
  var x5p: int;


  anon0:
    x1 := 0;
    x2 := 0;
    x3 := 0;
    x4 := 0;
    x5 := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    havoc x1p;
    havoc x2p;
    havoc x3p;
    havoc x4p;
    havoc x5p;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} !(0 <= x1p && x1p <= x4p + 1 && x2p == x3p && (x2p <= -1 || x4p <= x2p + 2) && x5p == 0);
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} 0 <= x1p && x1p <= x4p + 1 && x2p == x3p && (x2p <= -1 || x4p <= x2p + 2) && x5p == 0;
    x1 := x1p;
    x2 := x2p;
    x3 := x3p;
    x4 := x4p;
    x5 := x5p;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assert 0 <= x1 && x1 <= x4 + 1 && x2 == x3 && (x2 <= -1 || x4 <= x2 + 2) && x5 == 0;
    return;
}

