procedure insert(set: [int]int, size: int, value: int) returns (__RET: int)
{
  set[size] := value;
  __RET:=(size+1);
  return;
}procedure elem_exists(set: [int]int, size: int, value: int) returns (__RET: int)
{
  var i: int;
  i := 0;
  while ((i<size))
  invariant true;
  {
    if ((set[i]==value))
    {
      __RET:=1;
      return;    }

    i := i + 1;
  }
  __RET:=0;
  return;
}procedure main() returns (__RET: int)
{
  var n: int;
  var set: [int]int;
  var x: int;
  var y: int;
  var values: [int]int;
  var v: int;
  n := 0;
  x := 0;
  while ((x<n))
  invariant true;
  {
    y := (x+1);
    while ((y<n))
    invariant true;
    {
      assert((set[x]!=set[y]));
      y := y + 1;
    }
    x := x + 1;
  }
  v := 0;
  while ((v<100000))
  invariant true;
  {
    if (!(elem_exists(set,n,values[v])))
    {
      n := insert(set,n,values[v]);    }

    v := v + 1;
  }
  x := 0;
  while ((x<n))
  invariant true;
  {
    y := (x+1);
    while ((y<n))
    invariant true;
    {
      assert((set[x]!=set[y]));
      y := y + 1;
    }
    x := x + 1;
  }
  __RET:=0;
  return;
}