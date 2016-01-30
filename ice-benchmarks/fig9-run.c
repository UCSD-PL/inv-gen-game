#include <stdio.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();


//pre: true
int main() {

	int x, y;
	x = 0;
	y = 0;

	printf("x\ty\n");
	while(y >= 0) {
		printf("%d\t%d\n", x, y);
		y = y + x;	
	}
	printf("%d\t%d\n", x, y);

	__VERIFIER_assert(0 == 1);
}
