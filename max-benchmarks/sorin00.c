extern void __VERIFIER_error() __attribute__ ((__noreturn__));
extern void __VERIFIER_assume(int);
extern unsigned int __VERIFIER_nondet_int(void);
#include <assert.h>

void main()
{
 int y=__VERIFIER_nondet_int();
 int k=__VERIFIER_nondet_int();
 int x= y % k;
 while(x<k) {
	 //invariant (x == y mod k);
   x= y % k;
 }
 static_assert(x == y % k);
}

