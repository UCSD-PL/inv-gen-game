implementation main()
{
  var x1: int;
  var x2: int;
  var x3: int;
  var x4: int;
  var x5: int;
  var x6: int;
  var x7: int;
  var x8: int;
  var x1_: int;
  var x2_: int;
  var x3_: int;
  var x4_: int;
  var x5_: int;
  var x6_: int;
  var x7_: int;
  var x8_: int;


  anon0:
    x1 := 0;
    x2 := 0;
    x3 := 0;
    x4 := 0;
    x5 := 0;
    x6 := 0;
    x7 := 0;
    x8 := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    assume true;
    havoc x1_;
    havoc x2_;
    havoc x3_;
    havoc x4_;
    havoc x5_;
    havoc x6_;
    havoc x7_;
    havoc x8_;
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} !(x1_ <= x2_ && (x2_ >= 0 || x2_ - x3_ <= 2));
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} x1_ <= x2_ && (x2_ >= 0 || x2_ - x3_ <= 2);
    x1 := x1_;
    x2 := x2_;
    x3 := x3_;
    x4 := x4_;
    x5 := x5_;
    x6 := x6_;
    x7 := x7_;
    x8 := x8_;
    goto anon4_LoopHead;

  anon4_LoopDone:
    assume true;
    assert x1 <= x2 && (x2 >= 0 || x2 - x3 <= 2);
    return;
}

