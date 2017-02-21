// c/loop-lit/ddlm2013_true-unreach-call.c

procedure main()
{
  var i,j,a,b,flag: int;
  
  a := 0;
  b := 0;
  j := 1;
  
  /*
  if (flag != 0) {
    i := 0;
  } else {
    i := 1;
  }
  */
  // Encode if as assume to avoid loop duplication in desugaring
  assume(flag != 0 ==> i == 0);
  assume(flag == 0 ==> i == 1);  

  while (*)
  // invariant (flag != 0) ==> (j==i+1 && a == b && i mod 2 == 0);
  {
    a := a + 1;
    b := b + (j - i);
    i := i + 2;
    
    if (i mod 2 == 0) {
      j := j + 2;
    } else {
      j := j + 1;
    }
  }
  
  /*
  if (flag != 0) {
    assert (a == b); 
  }
  */
  // Encode if as implication so that our hacking postcond identification catches it.
  assert ((flag != 0) ==> a == b); 
}
