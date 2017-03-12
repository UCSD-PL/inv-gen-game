function {:existential true} b0(y:int, x:int): bool;
// dilig-benchmarks/single/04.c
/*
 * Taken from Gulwani PLDI'08:
 * Program Analysis as Constraint Solving
 */

procedure main() {
  var x,y: int;

  x := -50;

  while( x < 0 )
invariant b0(y, x);
  // invariant (y<=0) ==> x<0 ;
  {
    x := x+y;
    y := y + 1;
  }
  assert(y>0);
}
