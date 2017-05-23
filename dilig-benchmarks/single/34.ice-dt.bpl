function {:existential true} b0(y:int, i:int, m:int, x:int, n:int): bool;
// dilig-benchmarks/single/34.c
procedure main()
{
  var x,y,n,i,m : int;
  x:=0;
  y:=0;
  i:=0;
  m:=10;
 
  
  while(i<n)
invariant b0(y, i, m, x, n);
  // invariant (i mod 2 == 0 ==> x == 2 * y) && (i mod 2 == 1 ==> x == 2 * y + 1);
  {
    i:=i+1;
    x:=x+1;
    if (i mod 2 == 0)  {
      y:=y+1;
    } 
  } 
    
  assert(i == m ==> x == 2*y);   
}
