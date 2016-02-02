#include <assert.h>
#include <stdio.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

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

	input = 3;
 	while(input > 0) {
 		trace(0, "x=%dy=%d", (int32_t)x, (int32_t)y);
		x = x + 2;
		y = y + 2;
		--input;
	}
}

int main()
{
  int x=1,y=2;
  cegar1(1, 2);
  cegar1(2, 2);
  cegar1(2, 0);
  cegar1(0, 2);
  return 0;
}
