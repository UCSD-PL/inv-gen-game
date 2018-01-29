procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var j: int;
  i := 1;
  j := 0;
  while ((i<10000))
  invariant (forall k: int :: (0<=k && k < j) ==> a[k]==b[3*k+1]) && i==3*j+1;
  {
  a[j] := b[i];
  i := (i+3);
  j := (j+1);  }

  i := 1;
  j := 0;
  while ((i<10000))
  invariant (forall k: int :: (0<=k && 3*k+1 < 10000) ==> a[k]==b[3*k+1]) && i==3*j+1;
  {
  assert((a[j]==b[((3*j)+1)]));
  i := (i+3);
  j := (j+1);  }

  __RET:=0;
  return;
}
