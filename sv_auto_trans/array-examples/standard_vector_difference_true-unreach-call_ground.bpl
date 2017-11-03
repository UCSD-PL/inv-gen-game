procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var c: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  c[i] := (a[i]-b[i]);
  i := (i+1);  }

  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((c[x]==(a[x]-b[x])));
    x := x + 1;
  }
  __RET:=0;
  return;
}