function {:existential true} b0(x:int, m:int, n:int): bool;
// dilig-benchmarks/single/37.c
/*
 * Taken from "Counterexample Driven Refinement for Abstract Interpretation" (TACAS'06) by Gulavani
 */

procedure main() {
  var x,m,n : int;

  x:= 0;
  m:=0;

  while(x<n)
invariant b0(x, m, n);
  //invariant m >= 0 && (x > 0 ==> m < x) && m <= x && (n>0 ==> x <= n);
  {
     if(*) {
      m := x;
     }
     x := x+1;
  }

  assert(((n>0) ==> (0<=m && m<n)));
}
