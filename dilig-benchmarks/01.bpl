procedure run()
{
  var x, y, t1, t2, count, n: int;
  x := 1;
  y := 1;
  count := n;
  
  while(count > 0)
  // invariant x == y;
  {
    t1 := x;
    t2 := y;
    x := t1 + t2;
    y := t1 + t2;
    count := count - 1;
  }
}
