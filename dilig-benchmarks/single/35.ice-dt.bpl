function {:existential true} b0(x:int, n:int): bool;
// dilig-benchmarks/single/35.c
/*
 * InvGen, CAV'09 paper, fig 2
 */

procedure main() {
  var x,n : int;
  x := 0;

  while(x<n)
invariant b0(x, n);
  // invariant n > 0 ==> x <= n;
  {
    x:=x+1;
  }

  assert(n > 0 ==> x==n);
}

