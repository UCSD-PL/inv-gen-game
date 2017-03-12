function {:existential true} b0(x3:int, x2:int, c2:int, c1:int, x1:int, d2:int, d3:int, d1:int): bool;
procedure main()
{
  var d1, d2, d3, x1, x2, x3: int;
  var c1, c2: int;
  
  assume (d1 >= 0) && (d2 >= 0) && (d3 >= 0);
  assume (x1 >= 0) && (x2 >= 0) && (x3 >= 0);

  d1 := 1;
  d2 := 1;
  d3 := 1;
  
  while(x1 > 0 && x2 > 0 && x3 > 0)
invariant b0(x3, x2, c2, c1, x1, d2, d3, d1);
  // invariant x1 >= 0 && x2 >= 0 && x3 >= 0 && d1 == 1 && d2 == 1 && d3 == 1;
  {
    if (c1 != 0)
    {
      x1 := x1 - d1;
    }
    else if (c2 != 0)
    {
      x2 := x2 - d2;
    }
    else
    {
      x3 := x3 - d3;
    }
  }
  assert(x1 == 0 || x2 == 0 || x3 == 0);
}
