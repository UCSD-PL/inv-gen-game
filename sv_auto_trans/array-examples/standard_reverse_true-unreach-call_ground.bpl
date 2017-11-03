procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
    b[i] := a[((100000-i)-1)];
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((a[x]==b[((100000-x)-1)]));
    x := x + 1;
  }
  __RET:=0;
  return;
}