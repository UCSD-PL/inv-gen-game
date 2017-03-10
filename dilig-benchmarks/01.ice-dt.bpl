function {:existential true} b0(count:int, y:int, x:int): bool;
procedure run()
{
  var x, y, t1, t2, count, n: int;
  x := 1;
  y := 1;
  count := n;
  
  while(count > 0)
invariant b0(count, y, x);
  // invariant x == y && x >= 1;
  {
    t1 := x;
    t2 := y;
    x := t1 + t2;
    y := t1 + t2;
    count := count - 1;
  }
  assert (y>=1);
}
