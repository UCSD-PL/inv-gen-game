procedure strcmp(src: [int]int, dst: [int]int) returns (__RET: int)
{
  var i: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  if ((dst[i]!=src[i]))
  {
    __RET:=1;
    return;  }

  i := (i+1);  }

  __RET:=0;
  return;
}procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var c: int;
  c := strcmp(a,b);
  if ((c==0))
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