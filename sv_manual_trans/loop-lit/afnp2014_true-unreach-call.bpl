// c/loop-lit/afnp2014_true-unreach-call.c

procedure main()
{
  var x,y,z: int;
  x := 1;
  y := 0;
  
  while (y <  1000 && z == 1)
  // invariant x >= y;
  {
    havoc z;
    x := x + y;
    y := y + 1;
  }
  assert (x >= y);
}
