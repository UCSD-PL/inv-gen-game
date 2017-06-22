function {:existential true} b0(j:int, i:int, k:int, k:int): bool;

procedure main() {
  var i,j,k,z: int;
  j := 0;
  i := 0;
  z := 0;
  while (j < 1000)
  invariant b0(j, i, k, z);
  //invariant i == 5*j && i == z;
  {
    i := i + 5;
    j := j + 1;
    z := 5*j;
  }
  assert(i == z);
}
