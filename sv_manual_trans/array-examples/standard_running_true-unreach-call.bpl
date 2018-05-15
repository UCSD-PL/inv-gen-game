procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]bool;
  var i: int;
  var f: bool;
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < i) ==> ((b[k] && a[k] >= 0) || (!b[k] && a[k] < 0)));
  {
    if ((a[i]>=0))
    {
      b[i] := true;
    } else {
      b[i] := false;  
    }

    i := (i+1);  
  }

  f := true;
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < i) ==> ((b[k] && a[k] >= 0) || (!b[k] && a[k] < 0))) && f;
  {
    if (((a[i]>=0)&&!(b[i])))
    {
      f := false;
    }

    if (((a[i]<0)&&b[i]))
    {
      f := false;
    }

    i := (i+1);
  }

  assert(f);
  __RET:=0;
  return;
}

