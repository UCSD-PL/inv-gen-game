function {:existential true} b0(y:int, x:int, t:int): bool;
// dilig-benchmarks/single/43.c
/*
 * Based on ex16 from NECLA Static Analysis Benchmarks
 */

procedure main()
{
  var x,y,i,t : int;
  
  i := 0;
  t := y;
   
  if (x==y) {
    return;
  }
  
  while (*)
invariant b0(y, x, t);
  // invariant y >= t;
  {
    if (x > 0) {
      y := y + x;
    }
  }
  
  assert(y>=t);
}

