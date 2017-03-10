function {:existential true} b0(i:int, k:int, j:int, m:int, n:int, y:int, x:int): bool;
// dilig-benchmarks/single/20.c
procedure main()
{
    var x,y,k,j,i,n,m : int;
    
    assume((x+y)== k);
    m := 0;
    j := 0;
    while(j<n)
invariant b0(i, k, j, m, n, y, x);
    // invariant (x+y)==k && m >= 0 && j >= 0 && (m == 0 || m < n);
    {
      if(j==i)
      {
         x:=x+1;
         y:=y-1;
      }else
      {
         y:=y+1;
         x:=x-1;
      }
      
      if(*) {
        m := j;
      }
      
      j := j + 1;
    }
    
    assert((x+y)== k);
    assert ((n>0) ==> 0<=m);
    assert ((n>0) ==> m<n);
}
