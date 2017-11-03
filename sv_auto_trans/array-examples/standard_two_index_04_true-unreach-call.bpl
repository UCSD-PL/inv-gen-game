procedure main() returns (__RET: int)
{
  var a: [int]int;
  var b: [int]int;
  var i: int;
  var j: int;
  i := 1;
  j := 0;
  while ((i<100000))
  invariant true;
  {
  a[j] := b[i];
  i := (i+4);
  j := (j+1);  }

  i := 1;
  j := 0;
  while ((i<100000))
  invariant true;
  {
  assert((a[j]==b[((4*j)+1)]));
  i := (i+4);
  j := (j+1);  }

  __RET:=0;
  return;
}