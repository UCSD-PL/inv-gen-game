function {:existential true} b0(i:int, n:int, k:int, b:int, j:int): bool;
// dilig-benchmarks/single/32.bpl
/*
 * "split.c" from InvGen benchmark suite
 */
procedure main() {
  var k,b,i,j,n : int;

  k := 100;
  i := j;
  n := 0;

  assume (b == 0 || b == 1);

  while (n < 2*k )
invariant b0(i, n, k, b, j);
  // invariant (n mod 2 == 0 ==> i == j) && ((n mod 2 == 1 && b == 1) ==> i+1 == j) &&   ((n mod 2 == 1 && b == 0) ==> i == j+1) && (b == 0 || b == 1) && (n <= 2 * k);
  {

    if(b == 1) {
      i := i + 1;
    } else {
      j := j + 1;
    }
    b := 1 - b;
    n := n + 1;
  }
  assert(i == j);
}
