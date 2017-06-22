procedure main() {
  var i,j,k,z: int;
  j := 0;
  i := 0;
  z := 0;
  while (j < 1000)
  //invariant i == 5*j && i == z;
  {
    i := i + 5;
    j := j + 1;
    z := 5*j;
  }
  assert(i == z);
}
