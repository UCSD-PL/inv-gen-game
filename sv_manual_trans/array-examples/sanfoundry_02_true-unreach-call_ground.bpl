procedure main() returns (__RET: int)
{
  var array: [int]int;
  var i: int;
  var largest1: int;
  var largest2: int;
  var temp: int;
  var x: int;
  largest1 := array[0];
  largest2 := array[1];
  if ((largest1<largest2))
  {
    temp := largest1;
    largest1 := largest2;
    largest2 := temp;  }

  i := 2;
  while ((i<100000))
  invariant (forall k : int :: (0<=k && k < i) ==> (largest2 >= array[k] || largest1 == array[k] )) && largest1 >= largest2;
  {
    if ((array[i]>=largest1))
    {
      largest2 := largest1;
      largest1 := array[i];
    } else {
      if ((array[i]>largest2))
      {
        largest2 := array[i];
      }
    }

    i := i + 1;
  }
  x := 0;
  while ((x<100000))
  invariant (forall k : int :: (0<=k && k < 10000) ==> (largest2 >= array[k] || largest1 == array[k] )) && largest1 >= largest2 && x>=0 && x<=10000;
  {
    assert((array[x]<=largest1));
    x := x + 1;
  }
  x := 0;
  while ((x<100000))
  invariant (forall k : int :: (0<=k && k < 10000) ==> (largest2 >= array[k] || largest1 == array[k] )) && largest1 >= largest2;
  {
    assert(((array[x]<=largest2)||(array[x]==largest1)));
    x := x + 1;
  }
  __RET:=0;
  return;
}

