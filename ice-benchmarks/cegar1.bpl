procedure cegar1(x0: int, y0: int)
requires 0 <= x0 && x0 <= 2 && 0 <= y0 && y0 <= 2;
{
  var x, y: int;
  
  x := x0;
  y := y0;

  while (*)
  invariant (x - y <= 2 && y - x <= 2);
  {
	  x := x + 2;
	  y := y + 2;
  }
  assert(!((x == 4) && (y == 0)));
}

procedure main()
{
  var x, y: int;
  x := 2;
  y := 0;
  call cegar1(x, y);
}
