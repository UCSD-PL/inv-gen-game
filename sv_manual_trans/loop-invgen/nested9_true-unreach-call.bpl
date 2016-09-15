// c/loop-invgen/nested9_true-unreach-call.c

procedure main()
{   
    var i,j,k,n,l,m, LARGE_INT: int;

    //n = __VERIFIER_nondet_int();
    //m = __VERIFIER_nondet_int();
    //l = __VERIFIER_nondet_int();
    assume(LARGE_INT > 1000);
    assume(-LARGE_INT < n && n < LARGE_INT);
    assume(-LARGE_INT < m && m < LARGE_INT);
    assume(-LARGE_INT < l && l < LARGE_INT);
    if (3*n<=m+l) {
      i := 0;
      while (i < n) {
        j := 2 * i;
        while (j < 3) {
          k := i;
          while (k < j) {
            assert(k-i <= 2 * n);
            k := k + 1;
          }
          j := j + 1;
        }
        i := i + 1;
      }
    }
}
