#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int() {
	srand(time(NULL));
	int r = rand() % 2;
	return r;
}

void main() {

	int n;
	if (n <= 0)
		return;

	int x = 0;
	int input = __VERIFIER_nondet_int();

	printf("x\tn\t\n");
 	while ( 0 == 0 ) {
 		printf("%d\t%d\n", x, n);
		if ( input ) {

			x = x + 1;
			if (x >= n ) {
				break;
			}
		}
		input = __VERIFIER_nondet_int();
	}
	printf("%d\t%d\n", x, n);

	__VERIFIER_assert(x == n);

}
