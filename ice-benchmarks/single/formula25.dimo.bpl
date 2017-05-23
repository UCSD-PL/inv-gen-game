// ../ice-benchmarks/single/formula25.c

procedure main()
{

  var x1, x2, x3, x4, x5, x6, x7, x8: int;
  var x1_, x2_, x3_, x4_, x5_, x6_, x7_, x8_: int;

  x1 := 0;
  x2 := 0;
  x3 := 0;
  x4 := -1;
  x5 := 0;
  x6 := 0;
  x7 := 0;
  x8 := 0;

  while(*)
  // invariant (x1 <= 0 && x1 >= x4 + 1 && x2 == x3 && (x4 >= 0 || x4 <= x3));
  {
    havoc x1_;
    havoc x2_;
    havoc x3_;
    havoc x4_;
    havoc x5_;
    havoc x6_;
    havoc x7_;
    havoc x8_;

    if(x1_ <= 0 && x1_ >= x4_ + 1 && x2_ == x3_ && (x4_ >= 0 || x4_ <= x3_))
    {
      x1 := x1_;
      x2 := x2_;
      x3 := x3_;
      x4 := x4_;
      x5 := x5_;
      x6 := x6_;
      x7 := x7_;
      x8 := x8_;
    }
  }
  assert(x1 <= 0 && x1 >= x4 + 1 && x2 == x3 && (x4 >= 0 || x4 <= x3));
}

