procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var c: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  //invariant (forall k:int :: (0<=k && k < i) ==> c[k] == a[k] - b[k]) && i <= 100000;
  {
  c[i] := (a[i]-b[i]);
  i := (i+1);  }

  x := 0;
  while ((x<100000))
  //invariant (forall k:int :: (0<=k && k < 100000) ==> c[k] == a[k] - b[k]);
  {
    assert((c[x]==(a[x]-b[x])));
    x := x + 1;
  }
  __RET:=0;
  return;
}

