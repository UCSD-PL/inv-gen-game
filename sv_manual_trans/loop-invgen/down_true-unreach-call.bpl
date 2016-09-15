// c/loop-invgen/down_true-unreach-call.c

procedure main() {
  var n,i,j,k: int;
  k := 0;
  i := 0;
  // n = __VERIFIER_nondet_int();
  while( i < n )
  invariant n >= 0 ==> (i <= n && i == k);
  {
      i := i + 1; 
      k := k + 1;
  } 
  j := n;
  while( j > 0 )
  invariant j >= 0 ==> j == k;
  {
      assert(k > 0);
      j := j - 1;
      k := k - 1; 
  } 
}
