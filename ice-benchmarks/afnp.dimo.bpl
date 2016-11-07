procedure run() {
  // Translated flag from bool to int
  var x, y, flag: int;
  x := 1;
  y := 0;

  while (y < 10 && flag != 0)
  // invariant ((flag == 0) ==> (y == 0)) && ((flag != 0) ==> x >= y);
  {
  	x := x + y;
    y := y + 1;
  }
  assert(x >= y);
}
