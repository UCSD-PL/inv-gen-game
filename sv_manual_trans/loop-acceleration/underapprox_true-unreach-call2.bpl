// c/loop-acceleration/underapprox_true-unreach-call2.c

procedure main() {
  var x,y: int;
  x := 0;
  y := 1;
  while(x < 6)
  // invariant x <= 6;
  {
    x := x + 1;
    y := y * 2;
  }
  assert(x == 6);
}

