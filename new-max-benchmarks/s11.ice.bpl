function {:existential true} b0(i:int, j:int, k:int, l:int): bool;

procedure main() {
  var i,j,k,l: int;
  j := 0;
  i := l;
  while (j < 1000)
  invariant b0(i, j, k, l);
  //invariant i == l + k*j;
  {
    i := i + k;
    j := j + 1;
  }
  assert(i ==  l + k*j);
}
