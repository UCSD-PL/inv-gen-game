extern void __VERIFIER_assume(int);
extern int __VERIFIER_nondet_int();
#include <assert.h>

void main()
{
	int y=__VERIFIER_nondet_int();
	int k=__VERIFIER_nondet_int();
	int x= y % k;
	while(x<k && k>1) {
	 //invariant (x == y mod k);
		y = y + 2;
		k = k - 1;
		x= y % k;
	}
	static_assert(x == y % k);
}

