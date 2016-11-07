// ../ice-benchmarks/single/n_c11c.c

procedure main()
{
  var len, i: int;
  var N: int;
  var a: [int]int;
  len := 0;

  assume N > 0;
  while ( * )
  // invariant len <= N;
  {
    if (len == N)
    {
      len := 0;
    }
    if (len < 0 || len >= N + 1)
    {
      assert false;
    }
    len := len + 1;
  }
}

