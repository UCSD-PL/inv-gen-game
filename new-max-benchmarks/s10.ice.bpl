function {:existential true} b0(i:int, j:int, k:int): bool;

procedure main() {
  var i,j,k: int;
  j := 0;
  i := 10;
  while (j < 1000)
  invariant b0(i, j, k);
  //invariant i == 10 + k*j;
  {
    i := i + k;
    j := j + 1;
  }
  assert(i ==  10 + k*j);
}
