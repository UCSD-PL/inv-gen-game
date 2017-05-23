// dilig-benchmarks/single/30.c
/*
 * Based on "SYNERGY: A New Algorithm for Property Checking" by Gulavani et al.
 */

procedure main() {
  var i,c : int;

  i := 0;
  c := 0;
  while (i < 1000)
  //invariant c >= 0 && i >= 0;
  {
    c := c + i;
    i := i + 1;
  }

  assert(c>=0);
}
