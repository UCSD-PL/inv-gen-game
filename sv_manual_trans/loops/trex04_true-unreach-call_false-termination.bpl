// c/loops/trex04_true-unreach-call_false-termination.c

// Original function involved call to foo() - inlined.
procedure main()
{
  var d,x,y: int;
  d := 1;
  //int x = __VERIFIER_nondet_int();
  assume(x <= 1000000 && x >= -1000000);

  /*
  if (*) {
    d := d - 1;
  }
  if (*) {
      y:=0;
      if (*) {
        y := y + 1;
      }
      if (*) {
        y := y - 1;
      } else {
        y :=y + 10;
      }
  }

  if (*) {
      y:=0;
      if (*) {
        y := y + 1;
      }
      if (*) {
        y := y - 1;
      } else {
        y :=y + 10;
      }
  }
  if (*) {
    d := d - 1;
  }
  */
  // Encoding ifs as assumes to avoid loop duplication in desugaring
  assume(d == 1 || d == 0 || d == -1);

  while(x>0)
  // invariant true;
  {
    x:=x-d;
  }

  assert(x<=0);
}

