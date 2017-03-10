function {:existential true} b0(x:int, n:int): bool;
procedure main()
{
  var n, x, r : int;
  n := 0;
  x := 0;

  while (*)
invariant b0(x, n);
  // invariant n*n == x;
  {
    n := n + 1;
    x := x + 2*n - 1;
  }

  assert(x == n*n);    
}
