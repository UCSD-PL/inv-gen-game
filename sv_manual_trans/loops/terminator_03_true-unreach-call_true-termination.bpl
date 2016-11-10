// c/loops/terminator_03_true-unreach-call_true-termination.c

procedure main()
{
  var x,y,z, LIMIT: int;

  LIMIT := 1000000;
  //int x=__VERIFIER_nondet_int();
  //int y=__VERIFIER_nondet_int();
  assume(y <= LIMIT);
    
  if (y>0) {
    while(x<100)
    invariant true;
    {
      x:= x + y; 
    }
  }
  
  assert(y<=0 || (y>0 && x>=100));
}
