procedure main()
{
  var x, y, s, j : int;
  s := 0;

  assume x >= 0;
  
  j := 0;

  while(j < x)
  invariant s == y*j && j <= x;
  {
    s := s + y;
    j := j + 1;
  }
  
  assert(s == x*y);    
}
