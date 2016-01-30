#include <stdio.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int() {}

//pre: true
int main() {

	int x = -50;
	int y;

	printf("x\ty\n");
 	while (x < 0) {
 		printf("%d\t%d\n", x, y);
		x = x + y;
		y++;
	
	}
	printf("%d\t%d\n", x, y);
	__VERIFIER_assert(y > 0);

}
