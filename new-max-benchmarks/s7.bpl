procedure main() {
  var i,j,k,z: int;
  j := 0;
  i := 0;
  z := 0;
  while (j < 1000)
  //invariant i == k*j && i == z;
  {
    i := i + k;
    j := j + 1;
    z := k*j;
  }
  assert(i == z);
}
