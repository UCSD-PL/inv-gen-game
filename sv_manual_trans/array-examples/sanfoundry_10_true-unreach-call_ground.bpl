procedure main() returns (__RET: int)
{
  var i: int;
  var n: int;
  var pos: int;
  var element: int;
  var found: bool;
  var vectorx: [int]int;
  var x: int;
  n := 100000;
  found := false;
  i := 0;
  while (((i<n)&&!(found)))
  invariant (!(found) ==> (forall k: int :: (0<= k && k < i) ==> vectorx[k] != element));
  invariant found ==> ((forall k: int :: (0<= k && k < i-1) ==> vectorx[k] != element) && vectorx[i-1] == element && pos == i-1);
  {
    if ((vectorx[i]==element))
    {
      found := true;
      pos := i;
    }

    i := i + 1;
  }
  if (found)
  {
    i := pos;
    while ((i<(n-1)))
    invariant found ==> ((forall k: int :: (0<= k && k < pos) ==> vectorx[k] != element) && i >= pos);    
    {
      vectorx[i] := vectorx[(i+1)];
      i := i + 1;
    }
  }

  if (found)
  {
    x := 0;
    while ((x<pos))
    invariant (forall k: int :: (0<= k && k < pos) ==> vectorx[k] != element);
    {
      assert((vectorx[x]!=element));
      x := x + 1;
    }
  }

  __RET:=0;
  return;
}

