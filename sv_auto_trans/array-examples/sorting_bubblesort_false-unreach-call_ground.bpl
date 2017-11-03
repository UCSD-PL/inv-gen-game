procedure main() returns (__RET: int)
{
  var a: [int]int;
  var swapped: int;
  var x: int;
  var y: int;
  swapped := 1;
  while (swapped)
  invariant true;
  {
  swapped := 0;
  i := 1;
  while ((i<100000))
  invariant true;
  {
  if ((a[(i-1)]<a[i]))
  {
    t := a[i];
    a[i] := a[(i-1)];
    a[(i-1)] := t;
    swapped := 1;  }

  i := (i+1);  }
  }

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