function {:existential true} b0(i:int, x:int, j:int): bool;
// ../dilig-benchmarks/single/11.c
procedure main()
{
  var j,i,x : int;

  j := 0;
  x := 100;
  i := 0;

  while (i< x)
invariant b0(i, x, j);
  // invariant j==2*i && i <= x;
  {
    j  :=  j + 2;
    i := i + 1;
  }
  
  assert(j == 2*x);
}
