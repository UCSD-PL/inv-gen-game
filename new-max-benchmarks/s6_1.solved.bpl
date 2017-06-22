procedure main() {
  var i,j,k: int;
  j := 100;
  i := k*j;
  while (j > 0)
  invariant i == k*j;
  {
    i := i - k;
    j := j - 1;
  }
  assert(i ==  k*j);
}

