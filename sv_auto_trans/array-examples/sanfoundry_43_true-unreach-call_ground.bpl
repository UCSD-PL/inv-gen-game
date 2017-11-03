procedure incrementArray(src: [int]int, dst: [int]int)
{
  var i: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
    dst[i] := (src[i]+1);
    i := i + 1;
  }
}procedure main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var x: int;
  incrementArray(src,dst);
  x := 0;
  while ((x<100000))
  invariant true;
  {
    src[x] := (dst[x]-1);
    x := x + 1;
  }
  __RET:=0;
  return;
}