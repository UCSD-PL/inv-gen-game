extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{
  int j = 0;
  int i = 0;
  int k = __VERIFIER_nondet_int();
  int l = __VERIFIER_nondet_int();
  __VERIFIER_assume(k>=0);
  while (j < k)
  //invariant i == k*j*l;
  {
    i = i + l * k;
    j = j + 1;
  }
  assert(i ==  k*j*l);
}
