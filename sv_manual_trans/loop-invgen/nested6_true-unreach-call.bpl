// c/loop-invgen/nested6_true-unreach-call.c

procedure main()
{   
    var i,j,k,n, LARGE_INT: int;

    //k = __VERIFIER_nondet_int();
    //n = __VERIFIER_nondet_int();
    assume(n < LARGE_INT);
    
    if (k == n) {
      i := 0;
      while (i < n)
      invariant n > 0 ==> i <= n && k == n;
      {
        j := 2 * i;
        while (j < n)
        invariant j >= 2*i && k == n;
        {
          if (*) {
            k := j;
            while (k < n)
            invariant k >= j && k <= n;
            {
              assert(k >= 2*i);
              k := k + 1;
            }
          } else {
            assert(k >= n);
            assert(k <= n);
          }
          j := j + 1;
        }
        i := i + 1;
      }
    }  
}
