// c/loop-invgen/up_true-unreach-call.c

procedure main()
{
  var n, i, j, k : int;
  i := 0;
  k := 0;
  //n = __VERIFIER_nondet_int();
  while( i < n )
  // invariant n > 0 ==> (i == k && i <= n);
  {
    i := i + 1;
    k := k + 1;
  }
  j := 0;
  while( j < n )
  // invariant n > 0 ==> (j+k == n);
  {
    assert (k > 0);
    j := j + 1;
    k := k - 1;
  }
}
