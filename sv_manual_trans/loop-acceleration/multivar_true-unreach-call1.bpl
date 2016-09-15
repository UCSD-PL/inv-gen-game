// c/loop-acceleration/multivar_true-unreach-call1.c

procedure main() {
  var x, y: int;
  //unsigned int x = __VERIFIER_nondet_uint();
  y := x;
    
  while (x < 1024)
  invariant x == y ;
  {
    x := x + 1;
    y := y + 1;
  }

  assert(x == y);
}
