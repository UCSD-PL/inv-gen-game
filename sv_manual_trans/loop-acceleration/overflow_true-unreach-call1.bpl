// c/loop-acceleration/overflow_true-unreach-call1.c

procedure main() {
  var x : int;
  x := 10;
  
  while (x >= 10)
  invariant (x mod 2 == 0);
  {
    x := x + 2;
    
   if (x == 4294967296) { // uint32 overflow
      x := 0;
    }

  }

  assert(x mod 2 == 0);
}
