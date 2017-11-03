procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var incr: int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  a[i] := 42;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  invariant true;
  {
    b[i] := a[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  invariant true;
  {
    b[i] := (b[i]+incr);
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((b[x]==(42+incr)));
    x := x + 1;
  }
  __RET:=0;
  return;
}