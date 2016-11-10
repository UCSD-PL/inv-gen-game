// c/loop-acceleration/simple_true-unreach-call1.c

procedure main() {
  var x: int;
  x := 0;
  
  while (x < 268435455) // 0x0fffffff
  // invariant x mod 2 == 0;
  {
    x := x + 2;
  }

  assert((x mod 2) == 0);
}

