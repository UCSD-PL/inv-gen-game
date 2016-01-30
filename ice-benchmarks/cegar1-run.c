#include <stdio.h>

int __VERIFIER_assert(int a) {}

//pre: 0 <= x <= 2; 0 <= y <= 2
void cegar1(int x, int y) {

	int input;
	if (!(0 <= x))
		return;
	if (!(x <= 2))
		return;
	if (!(0 <= y))
		return;
	if (!(y <= 2))
		return;

	input = 10;

	printf("x\ty\n");

 	while ( input) {

 		printf("%d\t%d\n", x, y);

		x = x + 2;
		y = y + 2;

		--input;
	}
	__VERIFIER_assert(!((x == 4) && (y == 0)));

}
int main()
{
  int x=1,y=1;
  cegar1(x, y);
}
