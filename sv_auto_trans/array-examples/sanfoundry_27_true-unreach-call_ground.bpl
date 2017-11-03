procedure main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var largest: int;
  var x: int;
  largest := array[0];
  i := 1;
  while ((i<100000))
  invariant true;
  {
    if ((largest<array[i]))
    {
      largest := array[i];    }

    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((largest>=array[x]));
    x := x + 1;
  }
  __RET:=0;
  return;
}