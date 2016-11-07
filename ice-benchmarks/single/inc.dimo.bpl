// ice-benchmarks/single/inc.c
procedure main()
{
  var x, m: int;
  x := 0;
  while (x < 100)
  // invariant x <= 100;
  {
    havoc m;
    x := x + 1;
  }
  assert x == 100;
}

