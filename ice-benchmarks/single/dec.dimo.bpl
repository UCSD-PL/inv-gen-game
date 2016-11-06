procedure main()
{
  var x, m: int;
  x := 100;
  while (x > 0)
  //invariant x>=0;
  {
    havoc m;
    x := x - 1;
  }
  assert x == 0;
}

