procedure main() returns (__RET: int)
{
  var a1: [int]int;
  var a2: [int]int;
  var a3: [int]int;
  var a4: [int]int;
  var a5: [int]int;
  var a6: [int]int;
  var a7: [int]int;
  var i: int;
  var x: int;
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < i) ==> a2[k] == a1[k]) && i <= 100000;
  {
    a2[i] := a1[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a2[k]);
  //invariant (forall k : int :: (0 <= k && k < i) ==> a2[k] == a3[k]) && i <= 100000;
  {
    a3[i] := a2[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a2[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a2[k] == a3[k]);
  //invariant (forall k : int :: (0 <= k && k < i) ==> a3[k] == a4[k]) && i <= 100000;
  {
    a4[i] := a3[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a2[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a2[k] == a3[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a3[k] == a4[k]);
  //invariant (forall k : int :: (0 <= k && k < i) ==> a5[k] == a4[k]) && i <= 100000;
  {
    a5[i] := a4[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a2[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a2[k] == a3[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a3[k] == a4[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a5[k] == a4[k]);
  //invariant (forall k : int :: (0 <= k && k < i) ==> a5[k] == a6[k]) && i <= 100000;
  {
    a6[i] := a5[i];
    i := i + 1;
  }
  i := 0;
  while ((i<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a2[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a2[k] == a3[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a3[k] == a4[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a5[k] == a4[k]);
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a5[k] == a6[k]);
  //invariant (forall k : int :: (0 <= k && k < i) ==> a7[k] == a6[k]) && i <= 100000;
  {
    a7[i] := a6[i];
    i := i + 1;
  }

  x := 0;
  while ((x<100000))
  //invariant (forall k : int :: (0 <= k && k < 100000) ==> a1[k] == a7[k]);
  {
    assert((a1[x]==a7[x]));
    x := x + 1;
  }
  __RET:=0;
  return;
}
