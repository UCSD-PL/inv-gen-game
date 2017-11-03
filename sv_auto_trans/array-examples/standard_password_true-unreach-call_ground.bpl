procedure main() returns (__RET: int)
{
  var password: [int]int;
  var guess: [int]int;
  var i: int;
  var result: int;
  result := 1;
  i := 0;
  while ((i<100000))
  invariant true;
  {
    if ((password[i]!=guess[i]))
    {
      result := 0;    }

    i := i + 1;
  }
  if (result)
  {
    x := 0;
    while ((x<100000))
    invariant true;
    {
      assert((password[x]==guess[x]));
      x := x + 1;
    }  }

  __RET:=0;
  return;
}