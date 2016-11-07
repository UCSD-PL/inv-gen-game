// ice-benchmarks/single/tacas6.c
procedure main()
{
  var x, y, i, j: int;
  x := i;
  y := j;

  while (x != 0)
  // invariant i - j == x - y;
  {
    x := x - 1;
    y := y - 1;
  }

  assert (i == j) ==> y == 0;
}

