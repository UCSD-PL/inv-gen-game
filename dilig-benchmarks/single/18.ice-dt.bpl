function {:existential true} b0(flag:int, j:int, b:int): bool;
// dilig-benchmarks/single/18.c
/*
 * Adapted from ex17.c in NECLA test suite
 */

procedure main() {
   var flag, a, b, j : int;
   
   j := 0;
   b := 0;
   
   while(b < 100) 
invariant b0(flag, j, b);
   // invariant (flag != 0 ==> j == b) && b <= 100;
   {
      if (flag != 0) {
         j := j +1;
      }
      
      b := b + 1;
   }


   assert((flag != 0) ==> j==100);
}
