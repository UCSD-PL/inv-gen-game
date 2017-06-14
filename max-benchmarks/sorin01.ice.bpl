function {:existential true} b0(i:int, j:int, k:int): bool;

// Motivation: curious to see if other tools can handle this.
// This is a really simple benchmark, I'm assuming we have something 
// similar already?
procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  while (j < 1000)
  invariant b0(i, j, k);
  //invariant i == k*j;
  {
    i := i + k;
    j := j + 1;
  }
  assert(i ==  k*j);
}
