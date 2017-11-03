procedure main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var i: int;
  i := 0;
  while ((src[i]!=0))
  invariant true;
  {
  dst[i] := src[i];
  i := (i+1);  }

  i := 0;
  while ((src[i]!=0))
  invariant true;
  {
  assert((dst[i]==src[i]));
  i := (i+1);  }

  __RET:=0;
  return;
}