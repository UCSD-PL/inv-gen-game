function {:existential true} b0(a:int, x:int, sn:int): bool;
// c/loops/sum03_true-unreach-call_false-termination.c

procedure main()
{
  var sn, loop1, n1, x, a: int;
  sn:=0;
  a := 2;
  //unsigned int loop1=__VERIFIER_nondet_uint(), n1=__VERIFIER_nondet_uint();
  x:=0;
  
  while(x < 1000000)
invariant b0(a, x, sn);
  // invariant (sn == x * a);
  {
    sn := sn + a;
    x := x + 1;
    assert((sn==x*a) || (sn == 0));
  }
}
