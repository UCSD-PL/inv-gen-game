procedure main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;
  var y: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  k := i;
  s := (i+1);
  while ((k<100000))
  invariant true;
  {
  if ((a[k]>a[s]))
  {
    s := k;  }

  k := (k+1);  }

  if ((s!=i))
  {
    tmp := a[s];
    a[s] := a[i];
    a[i] := tmp;  }

  x := 0;
  while ((x<i))
  invariant true;
  {
    y := (x+1);
    while ((y<i))
    invariant true;
    {
      assert((a[x]<=a[y]));
      y := y + 1;
    }
    x := x + 1;
  }
  x := (i+1);
  while ((x<100000))
  invariant true;
  {
    assert((a[x]>=a[i]));
    x := x + 1;
  }
  i := (i+1);  }

  x := 0;
  while ((x<100000))
  invariant true;
  {
    y := (x+1);
    while ((y<100000))
    invariant true;
    {
      assert((a[x]<=a[y]));
      y := y + 1;
    }
    x := x + 1;
  }
  __RET:=0;
  return;
}