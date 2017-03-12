function {:existential true} b0(y:int, x:int, flag:int): bool;
procedure run() {
  // Translated flag from bool to int
  var x, y, flag: int;
  x := 1;
  y := 0;

  while (y < 10 && flag != 0)
invariant b0(y, x, flag);
  // invariant ((flag == 0) ==> (y == 0 && x == 1)) && ((flag != 0) ==> (x >= y && x >= 1 && y >= 0));
  {
  	x := x + y;
    y := y + 1;
  }
  assert(x >= y);
}
