// dilig-benchmarks/single/42.c
procedure main()
{
  var flag, x, y, a : int;
  x  :=  1;
  y  :=  1;
  
  if(flag != 0) {
    a  :=  0;
  } else {
    a  :=  1;
  }
  
  while(*) 
  // invariant (flag == 0 ==> (a mod 2 == 1 && (x+y) mod 2 == 0)) && (flag != 0 ==> (a mod 2 == 0 && (x + y) mod 2 == 0));
  {
    if(flag != 0)
    { 
      a  :=  x+y;
      x := x + 1;
    }
    else
    { 
      a := x+y+1;
      y := y + 1;
    }

    if(a mod 2==1) {
      y := y + 1;
    } else {
      x := x + 1;
    }
  }
  
  if(flag != 0) {
    a := a + 1;
  }

  assert(a mod 2==1);
}

