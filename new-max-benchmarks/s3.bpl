procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  while (j < 1000)
  invariant i == k*j;
  {
    i := i + 2* k;
    j := j + 2;
  }
  assert(i ==  k*j);
}
