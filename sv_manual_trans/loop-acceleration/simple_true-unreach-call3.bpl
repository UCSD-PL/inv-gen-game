// c/loop-acceleration/simple_true-unreach-call3.c

procedure main() {
  var x, N: int;
  x := 0;
  //unsigned short N = __VERIFIER_nondet_uint();
  
  while (x < N)
  invariant x mod 2 == 0;
  {
    x := x + 2;
  }

  assert((x mod 2) == 0);

}
