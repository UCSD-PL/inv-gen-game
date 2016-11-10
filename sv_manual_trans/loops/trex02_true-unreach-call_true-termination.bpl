// c/loops/trex02_true-unreach-call_true-termination.c

procedure main()
{
  var x: int;
  //x=__VERIFIER_nondet_int(); 

  while (x > 0)
  // invariant true;
  {
    if(*) {
      // foo inlined
      x := x - 1;
    } else {
      // foo inlined
      x := x - 1;
    }
  }
  assert(x<=0);
}
