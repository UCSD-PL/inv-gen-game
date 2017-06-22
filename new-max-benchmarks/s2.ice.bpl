function {:existential true} b0(j:int, i:int, k:int): bool;

procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  assume(k>=0);
  while (j < k)
  invariant b0(j, i, k);
  //invariant i == k*j && j <= k;
  {
    i := i + k;
    j := j + 1;
  }
  assert(i ==  k*k);
}
