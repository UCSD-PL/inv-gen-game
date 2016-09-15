// c/loop-invgen/seq_true-unreach-call.c

procedure main()
{
  var n0, n1, i0, i1, k, j1, LARGE_INT : int;

  //n0 = __VERIFIER_nondet_int();
  //n1 = __VERIFIER_nondet_int();
  assume(LARGE_INT > 1000);
  assume(-LARGE_INT <= n0 && n0 < LARGE_INT);
  assume(-LARGE_INT <= n1 && n1 < LARGE_INT);

  i0 := 0;
  k := 0;
  
  while( i0 < n0 ) 
  invariant i0 == k && (n0 > 0 ==> i0 <= n0) ;
  {
    i0 := i0 + 1;
    k := k + 1;
  }

  i1 := 0;
  while( i1 < n1 ) 
  invariant i0 + i1 == k && (n1 > 0 ==> i1 <= n1);
  {
    i1 := i1 + 1;
    k := k + 1;
  }
  
  j1 := 0;
  while( j1 < n0 + n1 )
 invariant j1 + k >= n0 + n1; 
  {
      assert(k > 0);
      j1 := j1 + 1; 
      k := k - 1;
  }
}
