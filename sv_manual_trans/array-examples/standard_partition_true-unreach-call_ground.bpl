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
  //invariant (forall k : int :: (0 <= k && k < b) ==> bb[k] >= 0);
  {
    if ((aa[a]>=0))
    {
      bb[b] := aa[a];
      b := (b+1);
    }

    a := (a+1);
  }

  a := 0;
  while ((a<100000))
  //invariant (forall k : int :: (0 <= k && k < c) ==> cc[k] < 0);
  {
  if ((aa[a]<0))
  {
    cc[c] := aa[a];
    c := (c+1);  
  }

  a := (a+1);  
  }

  x := 0;
  while ((x<b))
  //invariant true;
  {
    assert((bb[x]>=0));
    x := x + 1;
  }
  __RET:=0;
  return;
}

