procedure main() returns (__RET: int)
{
  var a: [int]int;
  var i: int;
  var x: int;
  i := 1;
  a[0] := 7;
  while ((i<100000))
  ////invariant (forall k: int :: (1 < k && k < i) ==> a[k] == a[k-1]+1) && i <= 100000;
  {
  a[i] := (a[(i-1)]+1);
  i := (i+1);  }

  x := 1;
  while ((x<100000))
  //invariant (forall k: int :: (1 < k && k < 100000) ==> a[k] >= a[k-1]+1);
  {
    assert((a[x]>=a[(x-1)]));
    x := x + 1;
  }
  __RET:=0;
  return;
}

