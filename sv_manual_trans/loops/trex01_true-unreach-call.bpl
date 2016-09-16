// c/loops/trex01_true-unreach-call.c

procedure main()
{
  var d, LARGE_INT, x,y,k,z: int;
  LARGE_INT := 1000000;
  
  if (*) {
    d := 1;
  } else {
    d := 2;
  }
  // f inlined
  //int x = __VERIFIER_nondet_int(), y = __VERIFIER_nondet_int(), k = __VERIFIER_nondet_int(),
  z := 1;
  
  while (z < k) { 
    z := 2 * z;
  }
  assert(z>=1);
  
  assume(x <= LARGE_INT && x >= -LARGE_INT);
  assume(y <= LARGE_INT && y >= -LARGE_INT);
  assume(k <= LARGE_INT && k >= -LARGE_INT);
  
  while (x > 0 && y > 0) {
    if (*) {
      x := x - d;
      if (*) {
        y := 0;
      } else {
        y := 1;
      }
      z := z - 1;
    } else {
      y := y - d;
    }
  }
}
