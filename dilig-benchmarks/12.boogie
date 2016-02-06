procedure run(u10: int, flag0, u20: bool)
requires u10 >= 0;
{
  var t, s, a, b, x, y, u1: int;
  var u2, flag: bool;

	t := 0;
	s := 0;
	a := 0;
	b := 0;
	u1 := u10;

	while(u1 != 0)
  invariant (flag ==> t == 2*s) && (!flag ==> t == s) && (a == b);
	{
		a := a + 1;
		b := b + 1;
		s := s + a;
		t := t + b;

		if(flag)
		{
			t := t + a;
		}

		u1 := u1 - 1;
	}

	x := 1;
	if(flag)
	{
    	x := t - 2 * s + 2;
  }
  y := 0;
  
  while(y <= x)
  invariant (u2 ==> y <= x + 1) && (!u2 ==> y <= x + 2) && (!flag ==> x == 1) && (flag ==> x == 2);
  {
  	if(u2)
   	{
   		y := y + 1;
   	}
   	else
   	{ 
		  y := y + 2;
	  }
  }  
	assert(y<=4);
}
