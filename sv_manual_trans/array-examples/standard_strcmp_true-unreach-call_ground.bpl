procedure strcmp(src: [int]int, dst: [int]int) returns (__RET: int)
ensures (__RET == 0 ==> (forall k:int :: (0 <= k && k < 100000) ==> src[k] == dst[k]));
{
  var i: int;
  i := 0;
  while ((i<100000))
  invariant (forall k:int :: (0 <= k && k < i) ==> src[k] == dst[k]);
  {
  if ((dst[i]!=src[i]))
  {
    __RET:=1;
    return;  }

  i := (i+1);  }

  __RET:=0;
  return;
}

procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var c,x: int;
  call c := strcmp(a,b);
  if ((c==0))
  {
    x := 0;
    while ((x<100000))
    invariant (c == 0 ==> (forall k:int :: (0 <= k && k < 100000) ==> a[k] == b[k]));
    {
      assert((a[x]==b[x]));
      x := x + 1;
    }  }

  __RET:=0;
  return;
}

