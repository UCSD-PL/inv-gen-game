procedure main()
{
  var x,y,k: int;
  x := y mod k;
  while (x<k)
  //invariant (x == y mod k);
  {
    // can enhance the benchmark by
    // assigning x,y,k new values here
    // using conditionals etc.
    x := y mod k;
  }
  assert(x == y mod k);
}
