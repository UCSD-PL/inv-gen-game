procedure main() returns (__RET: int)
{
  var A: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<(100000  div  2)))
  //invariant (forall k : int :: (0 <= k && k < i) ==> A[k] == A[100000-k-1]);
  {
    A[i] := A[((100000-i)-1)];
    i := i + 1;
  }
  x := 0;
  while ((x<(100000 div 2)))
  //invariant true;
  {
    assert((A[x]==A[((100000-x)-1)]));
    x := x + 1;
  }
  __RET:=0;
  return;
}

