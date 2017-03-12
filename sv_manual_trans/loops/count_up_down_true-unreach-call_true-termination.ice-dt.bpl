function {:existential true} b0(y:int, x:int, n:int): bool;
// c/loops/count_up_down_true-unreach-call_true-termination.c

procedure main()
{
  var n,x,y: int;
  //unsigned int n = __VERIFIER_nondet_uint();
  assume (n > 0);
  x := n;
  y := 0;
  
  while(x>0)
invariant b0(y, x, n);
  // invariant x+y == n && x >= 0;
  {
    x := x - 1;
    y := y + 1;
  }
  assert(y==n);
}
