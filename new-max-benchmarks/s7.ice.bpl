function {:existential true} b0(j:int, i:int, k:int, z:int): bool;

procedure main() {
  var i,j,k,z: int;
  j := 0;
  i := 0;
  z := 0;
  while (j < 1000)
  invariant b0(j, i, k, z);
  //invariant i == k*j && i == z;
  {
    i := i + k;
    j := j + 1;
    z := k*j;
  }
  assert(i == z);
}
