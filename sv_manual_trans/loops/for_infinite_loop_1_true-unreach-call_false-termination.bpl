// c/loops/for_infinite_loop_1_true-unreach-call_false-termination.c

procedure main()
{
  var i,x,y,n: int;
  i := 0;
  x := 0;
  y := 0;
  //int n=__VERIFIER_nondet_int();
  assume(n>0);
  
  while (true) {
    assert(x==0);
    i := i + 1;
  }
  assert(x==0);
}
