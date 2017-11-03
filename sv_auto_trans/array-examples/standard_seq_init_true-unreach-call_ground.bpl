procedure main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;
  i := 1;
  a[0] := 7;
  while ((i<100000))
  invariant true;
  {
  a[i] := (a[(i-1)]+1);
  i := (i+1);  }

  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((a[x]>=a[(x-1)]));
    x := x + 1;
  }
  __RET:=0;
  return;
}