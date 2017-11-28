procedure main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  invariant (forall k: int :: (0 <= k && k < i) ==> a2[k]==a1[k]) && i <= 100000;
  {
    a2[i] := a1[i];
    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant (forall k: int :: (0 <= k && k < 100000) ==> a2[k]==a1[k]);
  {
    assert((a1[x]==a2[x]));
    x := x + 1;
  }
  __RET:=0;
  return;
}

