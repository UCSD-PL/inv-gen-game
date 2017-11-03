procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var f: int;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  if ((a[i]>=0))
  {
    b[i] := 1;  } else {
    b[i] := 0;  }

  i := (i+1);  }

  f := 1;
  i := 0;
  while ((i<100000))
  invariant true;
  {
  if (((a[i]>=0)&&!(b[i])))
  {
    f := 0;  }

  if (((a[i]<0)&&!(b[i])))
  {
    f := 0;  }

  i := (i+1);  }

  assert(f);
  __RET:=0;
  return;
}