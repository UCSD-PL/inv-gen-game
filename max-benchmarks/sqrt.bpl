procedure sqrt()
{
  var n, x0, x1, q : int;
  assume(n > 0);
  x0 := n;
  x1 := 1;
  while ((x1 - x0)*(x1 - x0) >= 1 && x1 != x0 + 1)
  //invariant x0 div 2<= n;
  {
    x0 := x1;
    q := n div x0;
    x1 := (x0 + q) div 2;
  }

  assert(x0*x0 <= n);
  assert((x0 + 1)*(x0 + 1) > n);
}
