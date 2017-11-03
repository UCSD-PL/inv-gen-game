procedure main() returns (__RET: int)
{
  var i: int;
  var n: int;
  var pos: int;
  var element: int;
  var found: int;
  var vectorx: [int]int;
  n := 100000;
  found := 0;
  i := 0;
  while (((i<n)&&!(found)))
  invariant true;
  {
    if ((vectorx[i]==element))
    {
      found := 1;
      pos := i;    }

    i := i + 1;
  }
  if (found)
  {
    i := pos;
    while ((i<(n-1)))
    invariant true;
    {
      vectorx[i] := vectorx[(i+1)];
      i := i + 1;
    }  }

  if (found)
  {
    x := 0;
    while ((x<pos))
    invariant true;
    {
      assert((vectorx[x]!=element));
      x := x + 1;
    }  }

  __RET:=0;
  return;
}