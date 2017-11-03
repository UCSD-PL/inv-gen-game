procedure main() returns (__RET: int)
{
  var a: [int]int;
  var e: int;
  var i: int;
  var x: int;
  i := 0;
  while (((i<100000)&&(a[i]!=e)))
  invariant true;
  {
  i := (i+1);  }

  x := 0;
  while ((x<i))
  invariant true;
  {
    assert((a[x]!=e));
    x := x + 1;
  }
  __RET:=0;
  return;
}