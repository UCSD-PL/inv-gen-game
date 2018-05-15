procedure main() returns (__RET: int)
{
  var a: [int]int;
  var min: int;
  var i: int;
  var x: int;
  min := 0;
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < i) ==> min <= a[k]);
  {
  if ((a[i]<min))
  {
    min := a[i];  }

  i := (i+1);  }

  x := 0;
  while ((x<100000))
  //invariant true;
  {
    assert((a[x]>=min));
    x := x + 1;
  }
  __RET:=0;
  return;
}
