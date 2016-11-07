procedure main()
{
  var i, n, sn : int;
  //n :=__VERIFIER_nondet_int();
  sn := 0;
  i := 1;
  
  assume n >= 0;
  
  while (i <= n)
  // invariant ((n <= 0 ==> sn == 0) && sn == i - 1 && i <= n + 1);
  {
    sn := sn + 1;
    i := i + 1;
  }
  
  assert(sn == n || sn == 0);
}
