extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{  
  int n=0;
  int x=0;
  int y=1;
  int z=6;

  while( n < 100)
  //invariant (z == 6*n + 6  && y == 3*n*(n+1) + 1 && x == n*n*n ); 
  {
     n=n+1;
     x=x+y;
     y=y+z;
     z=z+6;
  }
  assert(x == n * n * n);
}

