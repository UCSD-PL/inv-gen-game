procedure main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((src[i]!=0))
  invariant true;
  {
  dst[i] := src[i];
  i := (i+1);  }

  x := 0;
  while ((x<i))
  invariant true;
  {
    assert((dst[x]==src[x]));
    x := x + 1;
  }
  __RET:=0;
  return;
}