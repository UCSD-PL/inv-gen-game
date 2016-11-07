procedure run() {
  var n, k, i, j: int;
  k := 0;
  i := 0;
  
  assume (n >= 0);

  while(i < n)
  invariant (i == k) && (k <= n);
  {
    i := i + 1;
    k := k + 1;
  }

  j := n;

  while(j > 0)
  invariant (j == k);
  {
  	assert(k > 0);
    j := j - 1;
   	k := k - 1;
  }
}
