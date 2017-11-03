procedure main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var r: int;
  r := 1;
  i := 1;
  while (((i<100000)&&r))
  invariant true;
  {
    j := (i-1);
    while (((j>=0)&&r))
    invariant true;
    {
      if ((a[i]==a[j]))
      {
        r := 1;      }

      j := j - 1;
    }
    i := i + 1;
  }
  if (r)
  {
    x := 0;
    while ((x<100000))
    invariant true;
    {
      y := (x+1);
      while ((y<100000))
      invariant true;
      {
        assert((a[x]!=a[y]));
        y := y + 1;
      }
      x := x + 1;
    }  }

  __RET:=0;
  return;
}