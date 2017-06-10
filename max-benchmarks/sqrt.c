extern void __VERIFIER_error() __attribute__ ((__noreturn__));
extern void __VERIFIER_assume(int);
extern int __VERIFIER_nondet_int();
#include <assert.h>

/*
 * Motivation: curious to see if other tools can handle this.
 * This is a really simple benchmark, I'm assuming we have something 
 * similar already?
 */ 

void sqrt()
{
	int n = __VERIFIER_nondet_int();
	__VERIFIER_assume(n > 0);
	int x0 = n;
	int x1 = 1;
	int q = __VERIFIER_nondet_int();
	while ((x1 - x0)*(x1 - x0) >= 1 && x1 != x0 + 1) {
		x0 = x1;
		q = n / x0;
		x1 = (x0 + q) / 2;
	}
	static_assert(x0*x0 <= n);
	static_assert((x0 + 1)*(x0 + 1) > n);
 }
