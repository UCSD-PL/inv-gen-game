function {:existential true} b0(k:int, j:int, n:int): bool;
procedure run(n: int) {
  var j, k: int;
  
  assume n > 0;
  assume k > n;
  
  j := 0;

  while( j < n )
invariant b0(k, j, n);
  // invariant j + k > n  && j <= n;
  {
    j := j + 1;
    k := k - 1;
  }
  assert k >= 0;
}
