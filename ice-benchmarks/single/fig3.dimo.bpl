// ../ice-benchmarks/single/fig3.c
procedure main()
{
  var x, y, lock: int;
  lock := 0;

  lock := 1;
  x := y;
  if (*)
  {
    lock := 0;
    y := y + 1;
  }

  while (x != y)
  invariant (x == y ==> lock == 1);
  {
    lock := 1;
    x := y;
    if (*)
    {
      lock := 0;
      y := y + 1;
    }
  }
  assert lock == 1;
}
