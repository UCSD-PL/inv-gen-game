procedure main() returns (__RET: int)
{
  var a: [int]int;
  var max: int;
  var i: int;
  var x: int;
  max := 0;
  i := 0;
  while ((i<100000))
  invariant (forall k : int :: (0 <= k && k < i) ==> max >= a[k]);
  {
    if ((a[i]>max))
    {
      max := a[i];
    }
  
    i := (i+1);
  }

  x := 0;
  while ((x<100000))
  invariant true;
  {
    assert((a[x]<=max));
    x := x + 1;
  }
  __RET:=0;
  return;
}

