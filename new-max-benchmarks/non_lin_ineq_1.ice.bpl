function {:existential true} b0(i:int, j:int, k:int): bool;

procedure main() {
  var i,j,k,l: int;
  i := 0;
  assume i*j<=k;
  while (i < 1000)
  invariant b0(i, j, k);
  //invariant i*j<=k;
  {
    i := i + 1;
    k := k + j;
  }
  assert(i*j<=k);
}
