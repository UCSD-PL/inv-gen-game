function {:existential true} b0(y:int, x:int): bool;
procedure main()
{
	var x, y : int;
	x := 0;
	y := 0;

	while(y >= 0)
invariant b0(y, x);
  // invariant y == 0 && x == 0;
	{
		y := y + x;	
	}

	assert(0 == 1);
}
