// ../ice-benchmarks/single/fig3.c
procedure main()
{
  var x, y, lock, choice: int;
  lock := 0;

  lock := 1;
  /*
  x := y;
  if (*)
  {
    lock := 0;
    y := y + 1;
  }
  */
  // Encoding above if as assumes to avoid loop duplication in desugaring
  assume (choice == 0 ==> (lock == 0 && y == x + 1));
  assume (choice != 0 ==> (lock == 1 && y == x));

  while (x != y)
  // invariant (x == y ==> lock == 1);
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
