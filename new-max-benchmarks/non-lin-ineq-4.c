extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{  
  int i = 0;
  int j = 1;
  int k = 0;
  while (i < 1000)
  //invariant i*i <= k;
  {
   i = i + 1;
   j = j + 1;
   k = k + i*j;
  }
  assert(1000*j<=k);
}
