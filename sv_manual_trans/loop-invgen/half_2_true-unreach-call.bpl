// c/loop-invgen/half_2_true-unreach-call.c

procedure main() {
  var n,i,j,k,LARGE_INT: int;
  //n = __VERIFIER_nondet_int();
  assume(n <= LARGE_INT);
  k := n;
  i := 0;
  while( i < n )
  // invariant k + i div 2 == n && (n > 0 ==> i <= n + 1);
  {
    k := k - 1;
    i := i + 2;
  }

  j := 0;

  while( j < (n div 2) )
  // invariant n > 0 ==> (k + j >= (n div 2));
  {
    assert(k > 0);
    k := k - 1;
    j := j + 1;
  }
}
