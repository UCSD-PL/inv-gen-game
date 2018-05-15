procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  //invariant (forall k: int :: (0 <=k && k < i) ==> a[k] == 42);
  {
  a[i] := 42;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  //invariant (forall k: int :: (0 <=k && k < i) ==> a[k] == b[k]);
  {
    b[i] := a[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k: int :: (i <=k && k < 100000) ==> a[k] == b[k]);
  //invariant (forall k: int :: (0 <=k && k < i) ==> a[k]+k == b[k]);
  {
    b[i] := (b[i]+i);
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k: int :: (i <=k && k < 100000) ==> a[k]+k == b[k]);
  //invariant (forall k: int :: (0 <=k && k < i) ==> k == b[k]);
  {
    b[i] := (b[i]-a[i]);
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  //invariant (forall k: int :: (0 <=k && k < 100000) ==> k == b[k]);
  {
    assert((b[x]==x));
    x := x + 1;
  }
  __RET:=0;
  return;
}

