procedure run(n: int) {
  var x: int;
  var y: int;
  var i: int;
  var m: int;

  x := 0;
  y := 0;
  i := 0;
  m := 10;

  while (i < n)
    invariant x == i && y == int(x/2);
  {
    i := i + 1;
    x := x + 1;

    if ((i - int(i/2) * 2) == 0)
    {
      y := y + 1;
    }
  }

  if (i == m)
  {
    assert x == 2*y;
  }
}
