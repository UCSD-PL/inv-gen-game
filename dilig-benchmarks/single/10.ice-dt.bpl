function {:existential true} b0(y:int, x:int, z:int, w:int): bool;
// dilig-benchmarks/single/10.c
procedure main() {
  var w,z,x,y : int;
  
  w := 1;
  z := 0;
  x := 0;
  y := 0;

  while(*)
invariant b0(y, x, z, w);
//  invariant x == y && w == 1-z;
  {
    if (w != 0) {
      x := x + 1;
      w := 1 - w;
    }

    if (z == 0) {
      y := y + 1;
      z := 1 - z;
    }
  }
  assert(x==y);
}
