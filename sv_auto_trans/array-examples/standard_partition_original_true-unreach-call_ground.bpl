procedure main() returns (__RET: int)
{
  var aa: [int]int;
  var a: int;
  var b: int;
  var c: int;
  var bb: [int]int;
  var cc: [int]int;
  var x: int;
  a := 0;
  b := 0;
  c := 0;
  while ((a<100000))
  invariant true;
  {
  if ((aa[a]>=0))
  {
    bb[b] := aa[a];
    b := (b+1);  } else {
    cc[c] := aa[a];
    c := (c+1);  }

  a := (a+1);  }

  x := 0;
  while ((x<b))
  invariant true;
  {
    assert((bb[x]>=0));
    x := x + 1;
  }
  x := 0;
  while ((x<c))
  invariant true;
  {
    assert((cc[x]<0));
    x := x + 1;
  }
  __RET:=0;
  return;
}