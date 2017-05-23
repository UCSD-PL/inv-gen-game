function {:existential true} b0(y:int, x:int, k:int, z:int): bool;
// dilig-benchmarks/single/22.bpl
procedure main()
{
  var x,y,z,k : int;
  x  :=  0;
  y  :=  0;
  z  :=  0;
  k  :=  0;

  while(*)
invariant b0(y, x, k, z);
  // invariant x == y && y == z && (k mod 3 == 0);
  {
     if(k mod 3 == 0) {
       x := x + 1;
     }
     y := y + 1;
     z := z + 1;
     k := x+y+z;
  }

  assert(x==y);
  assert(y==z);
}
