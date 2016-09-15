// c/loop-lit/gsv2008_true-unreach-call.c

procedure main() {
  var LARGE_INT: int;
  var x,y: int;
  LARGE_INT := 1000;
  x := -50;
  //y = __VERIFIER_nondet_int();
  assume(-1000 < y && y < LARGE_INT);
  while (x < 0)
  invariant y < 0 ==> x < 0;
  {
    x := x + y;
    y := y + 1;
  }
  assert(y > 0);
}

