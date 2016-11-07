procedure main()
{
  var x, s, y: int;
  assume (x >= 0);
  
  s := 0;
  
  while (s < x)
  invariant (s <= x);
  {
    s := s + 1;
  }

  y := 0;

  while (y < s)
  invariant (y <= x);
  {
    y := y + 1;
  }
  assert(y == x);
}
