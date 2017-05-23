function {:existential true} b0(i:int, y:int, j:int, x:int): bool;
// ice-benchmarks/single/tacas6.c
procedure main()
{
  var x, y, i, j: int;
  x := i;
  y := j;

  while (x != 0)
invariant b0(i, y, j, x);
  // invariant i - j == x - y;
  {
    x := x - 1;
    y := y - 1;
  }

  assert (i == j) ==> y == 0;
}

