procedure main() {
  var i,j,k: int;
  j := 0;
  i := k*j;
  while (j > 100)
  invariant -1<i && i<=0; //Alternative invariant found by ICE
  //invariant i == k*j;
  {
    i := i - k;
    j := j - 1;
  }
  assert(i ==  k*j);
}
