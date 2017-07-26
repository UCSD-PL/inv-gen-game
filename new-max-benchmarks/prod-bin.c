extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{  
  int a = __VERIFIER_nondet_int();
  __VERIFIER_assume(a>=0);
  int b = __VERIFIER_nondet_int();
  __VERIFIER_assume(b>=0);
  int x = a;
  int y = b;
  int z = 0;
  while (y != 0)
  //invariant (z+(x*y)==a*b); 
  { 
       if ( y % 2 == 1 ) {
         z = z+x;
         y = y-1;
       } else {
         x = 2*x;
         y = y / 2;
       }
  }

  assert(z==a*b);
}

