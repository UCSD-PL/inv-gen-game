procedure main() returns (__RET: int)
{
  var src: [int]int;
  var dst: [int]int;
  var i, i_old: int;
  i := 0;
  while ((src[i]!=0))
  invariant (forall k:int :: (0<=k && k < i) ==> dst[k] == src[k]) && i >= 0;
  {
  dst[i] := src[i];
  i := (i+1);}
  i_old := i; // Added by me
  i := 0;
  while ((src[i]!=0))
  invariant (forall k:int :: (0<=k && k < i_old) ==> dst[k] == src[k]) && src[i_old] == 0 && i <= i_old;
  {
  assert((dst[i]==src[i]));
  i := (i+1);  }

  __RET:=0;
  return;
}

