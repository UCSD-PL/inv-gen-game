procedure main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
    a2[i] := a1[i];
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((a1[x]==a2[x]));
    x := x + 1;
  }
  __RET:=0;
  return;
}