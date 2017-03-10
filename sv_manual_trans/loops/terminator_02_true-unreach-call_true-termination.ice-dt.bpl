function {:existential true} b0(x:int, z:int): bool;
// c/loops/terminator_02_true-unreach-call_true-termination.c

procedure main()
{
  var x,y,z: int;

  assume(x<100);
  assume(x>-100);
  assume(z<100);
  assume(z>-100);
  while(x<100 && 100<z)
invariant b0(x, z);
  // invariant x <= 100 && z <= 100;
  {
    if (*) {
      x := x + 1;
    } else {
      x := x - 1;
      z := z - 1;
    }
  }                       
  assert(x>=100 || z<=100);
}
