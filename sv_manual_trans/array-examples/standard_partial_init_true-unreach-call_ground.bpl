procedure main() returns (__RET: int)
{
  var A: [int]int;
  var B: [int]int;
  var C: [int]int;
  var i: int;
  var j: int;
  var x: int;
  j := 0;
  i := 0;
  while ((i<100000))
  //invariant j <= i && (forall k : int :: (0 <= k && k < j) ==> (C[k] >= k && C[k] <= k + i - j));
  {
    if ((A[i]==B[i]))
    {
      C[j] := i;
      j := (j+1);
    }
    i := i + 1;
  }
  x := 0;
  while ((x<j))
  //invariant true;
  {
    assert((C[x]<=((x+i)-j)));
    x := x + 1;
  }
  x := 0;
  while ((x<j))
  //invariant true;
  {
    assert((C[x]>=x));
    x := x + 1;
  }
  __RET:=0;
  return;
}

