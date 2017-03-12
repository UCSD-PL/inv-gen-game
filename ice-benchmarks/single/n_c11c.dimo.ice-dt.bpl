function {:existential true} b0(len:int, N:int): bool;
// ../ice-benchmarks/single/n_c11c.c

procedure main()
{
  var len, i: int;
  var N: int;
  var a: [int]int;
  len := 0;

  assume N > 0;
  while ( * )
invariant b0(len, N);
  // invariant len <= N && len >= 0 && N > 0;
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

