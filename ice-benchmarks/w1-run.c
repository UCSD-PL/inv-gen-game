#include <stdio.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int() {}

//pre: n >= 0
void main() {
	int n;
	if(n < 0)
	  return;

	int x = 0;

	printf("x\tn\n");

 	while (x < n) {
 		printf("%d\t%d\n", x, n);
		x = x + 1;
	}
	printf("%d\t%d\n", x, n);

	__VERIFIER_assert(x == n);

}
