procedure run(u1, u2: int)
{
  var w, z, x, y, u10, u20: int;
  
  w := 1;
  z := 0;
  x := 0;
  y := 0;
  u10 := u1;
  u20 := u2;

  while(u10 > 0)
  invariant w == z+1 && z <= x+y && ((z > 0) ==> (z == x + y));
  {
    while(u20 > 0)
    {
      if(w - int(w/2) * 2 == 1)
      {
        x := x + 1;
      }
      if(z - int(z/2) * 2 ==0)
      {
        y := y + 1;
      }
      
      u20 := u20 - 1;
    }
    z := x + y;
    w := z + 1;
    
    u10 := u10 - 1;
  }
  
  assert(x==y);
}
