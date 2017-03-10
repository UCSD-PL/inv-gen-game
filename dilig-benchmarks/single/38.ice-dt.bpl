function {:existential true} b0(i:int, y:int, n:int, x:int): bool;
procedure main()
{
  var n,x,y,i : int;

  x := 0;
  y := 0;
  i := 0;
  
  while(i<n)
invariant b0(i, y, n, x);
  // invariant ((i mod 2 == 0) ==> x == 2*y) && ((i mod 2 == 1) ==> x - 1 == 2 * y);
  {
    i:=i+1;
    x:=x+1;
    if(i mod 2 == 0) {
      y:=y+1;
    }
  }
  
  assert((i mod 2 == 0) ==> x==2*y);
}

