procedure run(n, l: int)
  requires l > 0;
{
  var i, k: int;
  
  k := 1;
  while (k < n)
  {
    i := 1;
    while (i < n)
    {
      i := i + 1;
    }
    i := 1;
    while (i < n)
    {
      assert 1 <= i;
      i := i + 1;
    }
    k := k + 1;
  } 
}