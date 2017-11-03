procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var rv: int;
  i := 0;
  rv := 1;
  while ((i<100000))
  invariant true;
  {
  if ((a[i]!=b[i]))
  {
    rv := 0;  }

  i := (i+1);  }

  if (rv)
  {
    x := 0;
    while ((x<100000))
    invariant true;
    {
      assert((a[x]==b[x]));
      x := x + 1;
    }  }

  __RET:=0;
  return;
}