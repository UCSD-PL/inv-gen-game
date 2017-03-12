function {:existential true} b0(y:int, x:int, s:int, j:int): bool;
procedure main()
{
  var x, y, s, j : int;
  s := 0;

  assume x >= 0;
  
  j := 0;

  while(j < x)
invariant b0(y, x, s, j);
  // invariant s == y*j && j <= x;
  {
    s := s + y;
    j := j + 1;
  }
  
  assert(s == x*y);    
}
