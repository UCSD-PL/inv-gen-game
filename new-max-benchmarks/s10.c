extern int __VERIFIER_nondet_int();
extern void __VERIFIER_assume(int);
#include <assert.h>

void main()
{
  int j = 0;
  int i = 10;
  int k = __VERIFIER_nondet_int();
  while (j < 1000)
  //invariant i == 10 + k*j;
  {
    i = i + k;
    j = j + 1;
  }
  assert(i ==  10 + k*j);
}
