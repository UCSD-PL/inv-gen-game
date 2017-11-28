procedure printEven(i: int)
requires i mod 2 == 0;
{
  assert(((i mod 2)==0));
}

procedure printOdd(i: int)
requires i mod 2 != 0;
{
  assert(((i mod 2)!=0));
}

procedure main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var num: int;
  i := 0;
  while ((i<num))
  invariant true;
  {
    if (((array[i] mod 2)==0))
    {
      call printEven(array[i]); 
    }

    i := i + 1;
  }
  i := 0;
  while ((i<num))
  invariant true;
  {
    if (((array[i] mod 2)!=0))
    {
      call printOdd(array[i]);
    }

    i := i + 1;
  }
  __RET:=0;
  return;
}

