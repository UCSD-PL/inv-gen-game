procedure main()returns ()
{
  var x,y,k: int;
  x := y mod k;
  while (x<k && k > 1)
  invariant (x == y mod k);
  {
    y := y + 2;
    k := k - 1;
    x := y mod k;
  }
  assert(x == y mod k);
}
