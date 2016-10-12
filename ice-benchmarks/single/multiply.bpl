function {:existential true} b0(s:int, j:int, x:int, y: int, ss: int, sj:int, sx: int, sy: int, jj: int, jx: int, jy: int, xx:int, xy: int, yy:int): bool;

procedure main()
{
  var x, y: int;
  var s: int;
  var j: int;
 
  assume (x >= 0);
 
  s := 0;
  j := 0;
  while (j < x)
  invariant b0(s,j,x,y,s*s,s*j,s*x,s*y,j*j,j*x,j*y,x*x,x*y,y*y);
  {
    s := s + y;
    j := j + 1;
  }
  assert (s == x*y);

}

