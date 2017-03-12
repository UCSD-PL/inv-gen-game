function {:existential true} b0(i:int, sum:int, n:int): bool;
/*
 * ex49 from NECLA Static Analysis Benchmarks
 */

procedure main(){
   var n,i,sum : int;

   sum := 0;
   i := 0;
   assume( n >= 0);

   while (i < n)
invariant b0(i, sum, n);
   // invariant i >= 0 && sum >= 0;
   {
      sum := sum +i;
      i := i + 1;
   }

   assert(sum >= 0);
}

