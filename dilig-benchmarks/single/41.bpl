// dilig-benchmarks/single/41.c
/*
 * Adapted from "Automated Error Diagnosis Using Abductive Inference" by Dillig et al.
 */
procedure main() {
  var n, flag, k, i, j, z : int;

  assume(n>=0);
  k := 1;
  if(flag != 0) {
    havoc k;
    assume(k>=0);
  }
  i := 0;
  j := 0;

  while(i <= n) 
  // invariant j >= i;
  {
     i := i + 1;
     j := j + i;
  }
  z := k + i + j;
  assert(z > 2*n);
}

