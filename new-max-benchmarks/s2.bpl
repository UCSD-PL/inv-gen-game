procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  assume(k>=0);
  while (j < k)
  //invariant i == k*j && j <= k;
  {
    i := i + k;
    j := j + 1;
  }
  assert(i ==  k*k);
}
