procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var j: int;
  i := 1;
  j := 0;
  while ((i<100000))
  //invariant (forall k: int :: (0<=k && k < j) ==> a[k]==b[2*k+1]) && i==2*j+1;
  {
  a[j] := b[i];
  i := (i+2);
  j := (j+1);  }

  i := 1;
  j := 0;
  while ((i<100000))
  //invariant (forall k: int :: (0<=k && 2*k+1 < 100000) ==> a[k]==b[2*k+1]) && i==2*j+1;
  {
  assert((a[j]==b[((2*j)+1)]));
  i := (i+2);
  j := (j+1);  }

  __RET:=0;
  return;
}

