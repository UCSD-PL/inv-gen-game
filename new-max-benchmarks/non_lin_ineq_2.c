extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{
  int j = __VERIFIER_nondet_int();
  int i = 0;
  int k = __VERIFIER_nondet_int();
  
  __VERIFIER_assume(j > 0);
  __VERIFIER_assume(k > 0);

  
  while (i < j*k)
  //invariant i <= j*k;
  {
    i = i + 1;
  }
  assert(i == j*k);
}
