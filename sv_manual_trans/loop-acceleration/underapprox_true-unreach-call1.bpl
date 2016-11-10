// c/loop-acceleration/underapprox_true-unreach-call1.c

procedure main() {
  var x, y: int;
  x := 0;
  y := 1;

  while (x < 6)
  // invariant y mod 3 != 0;
  {
    x := x + 1;
    y := y * 2;
  }

  assert(y mod 3 != 0);
}
