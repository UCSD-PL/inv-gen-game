function {:existential true} b0(c2:int, x2:int, x3:int, c1:int, x1:int, d2:int, d3:int, d1:int): bool;
// c/loops/trex03_true-unreach-call.c

procedure main()
{
  var x1,x2,x3, d1,d2,d3, c1,c2: int;
  //unsigned int x1=__VERIFIER_nondet_uint(), x2=__VERIFIER_nondet_uint(), x3=__VERIFIER_nondet_uint();
  assume x1 >= 0 && x2 >= 0 && x3 >= 0; // unsigned ints
  d1 := 1;
  d2 := 1;
  d3 := 1;
  
  /*
  if (*) {
    c1 := 0;
  } else {
    c1 := 1;
  }
  
  if (*) {
    c2 := 0;
  } else {
    c2 := 1;
  }
  */
  // Encode ifs as assumes to avoid apparent loop duplication
  assume(c1 == 0 || c1 == 1);
  assume(c2 == 0 || c2 == 1);
  
  while(x1>0 && x2>0 && x3>0)
invariant b0(c2, x2, x3, c1, x1, d2, d3, d1);
  // invariant x1 >= 0 && x2 >= 0 && x3 >= 0;
  { 
    if (c1 != 0) {
      x1 := x1-d1;
    } else if (c2 != 0) {
      x2 := x2-d2;
    } else {
      x3 :=x3-d3;
    }
  
    if (*) {
      c1 := 0;
    } else {
      c1 := 1;
    }
  
    if (*) {
      c2 := 0;
    } else {
      c2 := 1;
    }
  }
  
  assert(x1==0 || x2==0 || x3==0);
}
