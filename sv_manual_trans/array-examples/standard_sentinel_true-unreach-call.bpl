procedure main() returns (__RET: int)
{
  var a: [int]int;
  var marker: int;
  var pos: int;
  var i: int;
  if (((pos>=0)&&(pos<100000)))
  {
    a[pos] := marker;
    i := 0;
    while ((a[i]!=marker))
    invariant (forall k : int :: (0 <= k && k < i) ==> a[k] != marker) && a[pos] == marker && i <= pos;
    {
      i := (i+1);
    }

    assert((i<=pos));  
  }

  __RET:=0;
  return;
}
