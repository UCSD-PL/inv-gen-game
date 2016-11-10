// c/loops/sum01_true-unreach-call_true-termination.c

procedure main()
{
  var i,n,sn,a: int;
  
  a:= 2;
  sn:=0;
  // n=__VERIFIER_nondet_int()
  
  assume(n < 1000 && n >= -1000);
  i:=1;
  while (i<=n)
  // invariant (sn == (i-1) * a) && (n >= 0 ==> i <=n+1) && (n < 0 ==> sn == 0);
  {
    sn := sn + a;
    i := i + 1;
  }
  assert(sn==n*a || sn == 0);
}
