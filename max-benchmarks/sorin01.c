extern int __VERIFIER_nondet_int();
#include <assert.h>

/*
 * Motivation: curious to see if other tools can handle this.
 * This is a really simple benchmark, I'm assuming we have something 
 * similar already?
 */ 

void main()
{
	int k = __VERIFIER_nondet_int();
 int j=0; int i=0;
 while(j<1000) {
   i = i + k;
   j = j + 1;
 }
 static_assert(i==k*j);
}

