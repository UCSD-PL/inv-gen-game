procedure main() returns (__RET: int)
{
  var a: [int]int;
  var swapped: bool;
  var x: int;
  var y: int;
  var i, t: int;
  swapped := true;
  while (swapped)
  //invariant (!swapped ==> (forall k,l : int :: (0 <= k && k < l && l < 100000) ==> a[k] <= a[l]));
  {
    swapped := false;
    i := 1;
    while ((i<100000))
    //invariant (forall k : int :: (0 <= k && k < i) ==> a[k] <= a[i-1]);
    //invariant (!swapped ==> (forall k,l : int :: (0 <= k && k < l && l < i) ==> a[k] <= a[l]));
    {
      if ((a[(i-1)]>a[i]))
      {
        t := a[i];
        a[i] := a[(i-1)];
        a[(i-1)] := t;
        swapped := true;
      }

      i := (i+1);
    }
  }

  x := 0;
  while ((x<100000))
  //invariant true;
  {
    y := (x+1);
    while ((y<100000))
    //invariant x<y;
    {
      assert((a[x]<=a[y]));
      y := y + 1;
    }
    x := x + 1;
  }
  __RET:=0;
  return;
}

