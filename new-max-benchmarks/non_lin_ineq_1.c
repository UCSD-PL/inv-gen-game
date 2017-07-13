extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{
  int j = __VERIFIER_nondet_int();
  int i = 0;
  int k = __VERIFIER_nondet_int();
  int l = __VERIFIER_nondet_int();
  
  __VERIFIER_assume(i*j<=k);
  while (i < 1000)
  //invariant i*j<=k;
  {
    i = i + 1;
    k = k + j;
  }
  assert(i*j<=k);
}
