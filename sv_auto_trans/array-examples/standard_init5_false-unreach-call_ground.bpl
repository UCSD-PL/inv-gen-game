procedure main() returns (__RET: int)
{
  var a: [int]int;
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
  a[i] := 43;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  invariant true;
  {
  a[i] := 44;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  invariant true;
  {
  a[i] := 45;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  invariant true;
  {
  a[i] := 46;
  i := (i+1);  }

  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((a[x]==45));
    x := x + 1;
  }
  __RET:=0;
  return;
}