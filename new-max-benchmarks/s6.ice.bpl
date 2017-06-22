function {:existential true} b0(j:int, i:int, k:int): bool;

procedure main() {
  var i,j,k: int;
  j := 0;
  i := k*j;
  while (j > 100)
  invariant b0(j, i, k);
  //invariant i == k*j;
  {
    i := i - k;
    j := j - 1;
  }
  assert(i ==  k*j);
}
