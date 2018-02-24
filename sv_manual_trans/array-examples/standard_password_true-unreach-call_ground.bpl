procedure main() returns (__RET: int)
{
  var password: [int]int;
  var guess: [int]int;
  var i: int;
  var result: bool;
  var x: int;
  result := true;
  i := 0;
  while ((i<100000))
  //invariant result ==> (forall k : int :: (0 <= k && k < i) ==> password[k] == guess[k]);
  {
    if ((password[i]!=guess[i]))
    {
      result := false;
    }

    i := i + 1;
  }
  
  if (result)
  {
    x := 0;
    while ((x<100000))
    //invariant true;
    {
      assert((password[x]==guess[x]));
      x := x + 1;
    }
  }

  __RET:=0;
  return;
}

