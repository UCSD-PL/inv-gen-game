procedure main()
{
  var n, a, su, t : int;

  a := 0;
  su := 1;
  t := 1;

  while (su <= n)
  // invariant (a * a <= su) && ((a+1) * (a+1) > n);
  {
    a := a + 1;
    t := t + 2;
    su := su + t;
  }

  assert((a*a <= n) && ((a+1)*(a+1) > n));
}
