extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{  
  int i = 0;
  int k = 0;
  while (i < 1000)
  //invariant i*i <= k;
  {
   i = i + 1;
   k = k + i*i;
  }
  assert(1000000<=k);
}
