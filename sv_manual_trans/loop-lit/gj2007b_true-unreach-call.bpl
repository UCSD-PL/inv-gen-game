// c/loop-lit/gj2007b_true-unreach-call.c

procedure main() {
  var x,m,n: int;
  x := 0;
  m := 0;
  //int n = __VERIFIER_nondet_int();
    
  while(x < n)
  invariant (n > 0 ==> m < n);
  {
    if(*) {
      m := x;
    }
    x := x + 1;
  }
  assert((m >= 0 || n <= 0));
  assert((m < n || n <= 0));
}

