function {:existential true} b0(y:int, x:int, z:int): bool;
// c/loop-lit/afnp2014_true-unreach-call.c

procedure main()
{
  var x,y,z: int;
  x := 1;
  y := 0;
  
  while (y <  1000 && z == 1)
invariant b0(y, x, z);
  // invariant x >= y;
  {
    havoc z;
    x := x + y;
    y := y + 1;
  }
  assert (x >= y);
}
