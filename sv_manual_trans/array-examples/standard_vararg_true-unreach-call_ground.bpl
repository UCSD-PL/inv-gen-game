procedure main() returns (__RET: int)
{
  var aa: [int]int;
  var a: int;
  var x: int;
  a := 0;
  while ((aa[a]>=0))
  invariant (forall k: int :: (0 <= k && k < a) ==> aa[k] >= 0);
  {
  a := a + 1;  }

  x := 0;
  while ((x<a))
  invariant (forall k: int :: (0 <= k && k < a) ==> aa[k] >= 0);
  {
    assert((aa[x]>=0));
    x := x + 1;
  }
  __RET:=0;
  return;
}

