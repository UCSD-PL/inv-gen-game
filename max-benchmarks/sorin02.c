extern void __VERIFIER_error() __attribute__ ((__noreturn__));
extern void __VERIFIER_assume(int);
extern unsigned int __VERIFIER_nondet_int(void);
#include <assert.h>

/*
 * Motivation: curious to see if other tools can handle this.
 * This is a really simple benchmark, I'm assuming we have something 
 * similar already?
 */ 

void main()
{
	int n = __VERIFIER_nondet_int();
	__VERIFIER_assume(n>0);
	int a = 1;
	int su = 1;
	int t = 1;
 while(su <= n) {
   t = t + 2;
   su = su + t;
   a = a + 1;
 }
 static_assert((a*a == su));
}

