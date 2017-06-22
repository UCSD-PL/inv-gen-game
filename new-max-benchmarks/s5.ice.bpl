function {:existential true} b0(j:int, i:int, k:int): bool;

procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  assume(k>=0);
  while (j < k)
  invariant b0(j, i, k);
  //invariant i == 2* k*j;
  {
    i := i + 2* k;
    j := j + 1;
  }
  assert(i ==  2*k*j);
}
