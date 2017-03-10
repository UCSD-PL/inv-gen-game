function {:existential true} b0(i:int, j:int): bool;
// c/loop-lit/cggmp2005_true-unreach-call.c 

procedure main()
{
  var i,j: int;
  i := 1;
  j := 10;
  
  while (j >= i) 
invariant b0(i, j);
  // invariant j >= i-3 && (j-i) mod 3 == 0 && 2* (10 - j) == i - 1; 
  {
    i := i + 2;
    j := -1 + j;
  }
  
  assert(j == 6);
}

