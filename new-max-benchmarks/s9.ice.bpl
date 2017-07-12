function {:existential true} b0(i:int, j:int, k:int, l:int): bool;

procedure main() {
  var i,j,k,l: int;
  j := 0;
  i := 0;
  assume(k>=0);
  while (j < k)
  invariant b0(i, j, k, l);
  //invariant i == k*j*l;
  {
    i := i + l * k;
    j := j + 1;
  }
  assert(i ==  k*j*l);
}
