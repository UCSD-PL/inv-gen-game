procedure printEven(i: int)
{
  assert(((imod2)==0));
}procedure printOdd(i: int)
{
  assert(((imod2)!=0));
}procedure main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var num: int;
  i := 0;
  while ((i<num))
  invariant true;
  {
    if (((array[i]mod2)==0))
    {
      printEven(array[i]);    }

    i := i + 1;
  }
  i := 0;
  while ((i<num))
  invariant true;
  {
    if (((array[i]mod2)!=0))
    {
      printOdd(array[i]);    }

    i := i + 1;
  }
  __RET:=0;
  return;
}