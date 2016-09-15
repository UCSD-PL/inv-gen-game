// c/loop-new/nested_true-unreach-call.c

procedure main() {
  var n,m,k,i,j: int;
  //int n = __VERIFIER_nondet_int();
  //int m = __VERIFIER_nondet_int();
  k := 0;
  assume(10 <= n && n <= 10000);
  assume(10 <= m && m <= 10000);
  
  i := 0;
  while (i < n) 
  invariant k >= i * m; 
  {
    j := 0;
    while (j < m) 
    invariant k >= i * m + j && j <= m;
    {
      k := k + 1;
      j := j + 1;
    }
    i := i + 1;
  }

  assert(k >= 100);
}

