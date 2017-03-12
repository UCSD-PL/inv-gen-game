function {:existential true} b0(i:int, y:int, j:int, z:int, x:int): bool;
// c/loop-lit/jm2006_variant_true-unreach-call.c

procedure main()
{
  var i,j, LARGE_INT: int;
  var x,y,z: int;
  
  LARGE_INT := 1000;
  assume i >= 0 && i <= LARGE_INT;
  assume j >= 0;
  
  x := i;
  y := j;
  z := 0;
  
  while (x != 0) 
invariant b0(i, y, j, z, x);
  // invariant i == j ==> x-y == z;
  {
    x := x - 1;
    y := y - 2;
    z := z + 1;  
  }
  
  if (i == j) {
    assert (y == -z);  
  }
}
