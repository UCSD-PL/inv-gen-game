function {:existential true} b0(y:int, x:int): bool;
// c/loop-acceleration/phases_true-unreach-call2.c

procedure main() {
  var x, y: int;
  x := 1;
  //unsigned int y = __VERIFIER_nondet_uint();
  assume y > 0;
  
  while (x < y)
invariant b0(y, x);
  // invariant (x <= y);
  {
    if (x < y div x) {
      x := x * x;
    } else {
      x := x + 1;
    }
  }

  assert(x == y);
}
