function {:existential true} b0(i:int, k:int): bool;
//NON-LIN-INEQ-3
procedure main() {
 var i,k: int;
 i := 0;
 k := 0;
 while (i < 1000)
 //invariant i*i <= k;
 invariant b0(i, k);
 {
   i := i + 1;
   k := k + i*i;
 }
 assert(1000000<=k);
}