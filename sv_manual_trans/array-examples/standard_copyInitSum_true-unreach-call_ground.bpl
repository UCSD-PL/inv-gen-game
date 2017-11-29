procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var incr: int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant (forall k : int :: (0 <= k && k < i) ==> a[k] == 42);
  {
  a[i] := 42;
  i := (i+1);  }

  i := 0;
  while ((i<100000))
  invariant (forall k : int :: (0 <= k && k < i) ==> a[k] == b[k]);
  {
    b[i] := a[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  invariant (forall k : int :: (i <= k && k < 100000) ==> a[k] == b[k]);
  invariant (forall k : int :: (0 <= k && k < i) ==> a[k]+incr == b[k]);
  {
    b[i] := (b[i]+incr);
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant (forall k : int :: (0 <= k && k < 100000) ==> a[k] == 42);
  invariant (forall k : int :: (0 <= k && k < 100000) ==> a[k]+incr == b[k]);
  {
    assert((b[x]==(42+incr)));
    x := x + 1;
  }
  __RET:=0;
  return;
}

