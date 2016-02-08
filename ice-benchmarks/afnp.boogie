procedure run(flag: bool) {
  var x, y: int;
  x := 1;
  y := 0;

  while (y < 10 && flag)
  invariant (!flag ==> (y == 0)) && (flag ==> x >= y);
  {
  	x := x + y;
    y := y + 1;
  }
  assert(x >= y);
}