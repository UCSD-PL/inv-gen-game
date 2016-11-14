procedure main()
{
  var i,n,sn:int;
  
  sn := 0;
  i := 1;
  
  while (i <= n) 
  invariant true;
  {
    sn := sn + 1;
    i := i + 1;
  }
  
  assert sn == n || sn == 0;
}

