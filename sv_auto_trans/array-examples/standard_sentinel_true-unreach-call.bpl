procedure main() returns (__RET: int)
{
  var a: [int]int;
  var marker: int;
  var pos: int;
  if (((pos>=0)&&(pos<100000)))
  {
    a[pos] := marker;
    i := 0;
    while ((a[i]!=marker))
    invariant true;
    {
    i := (i+1);    }

    assert((i<=pos));  }

  __RET:=0;
  return;
}