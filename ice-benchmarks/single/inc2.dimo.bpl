// ice-benchmarks/single/inc2.c

procedure main()
{
  var x, N: int;
  x := 0;
  while (x < N)
  // invariant (N >= 0) ==> x <= N;
  {
    x := x + 1;
  }
  assert N < 0 || x == N;
}

