// c/loop-acceleration/simple_true-unreach-call2.c

procedure main() {
  var x: int;
 
  while(x < 268435455) // 0x0fffffff
  // invariant true;
  {
    x := x + 1;
  }
  assert(x >= 268435455);
}

