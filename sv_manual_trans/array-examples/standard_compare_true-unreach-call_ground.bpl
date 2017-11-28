procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var rv: bool;
  var x: int;
  
  i := 0;
  rv := true;
  while ((i<100000))
  invariant rv ==> (forall k : int :: (0 <= k && k < i) ==> a[k] == b[k]);
  {
    if ((a[i]!=b[i]))
    {
      rv := false;
    }

    i := (i+1);
  }

  if (rv)
  {
    x := 0;
    while ((x<100000))
    invariant rv ==> (forall k : int :: (0 <= k && k < 100000) ==> a[k] == b[k]);
    {
      assert((a[x]==b[x]));
      x := x + 1;
    }  
  }

  __RET:=0;
  return;
}

