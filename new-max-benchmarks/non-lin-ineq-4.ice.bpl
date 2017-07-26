function {:existential true} b0(i:int, j:int, k:int): bool;
//NON-LIN-INEQ-4
procedure main() {
 var i,j,k: int;
 i := 0;
 j := 1;
 k := 0;
 while (i < 1000)
 //invariant i*j <= k;
 invariant b0(i, j, k);
 {
   i := i + 1;
   j := j + 1;
   k := k + i*j;
 }
 assert(1000*j<=k);
}

