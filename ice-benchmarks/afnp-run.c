#include <stdio.h>

void run(int flag) {
  int x = 1;
  int y = 0;

  printf("flag\tx\ty\n");
  while (y < 1000 && (flag != 0)) {
    printf("%d\t%d\t%d\n", flag, x, y);
  	x = x + y;
    y = y + 1;
  }
  printf("%d\t%d\t%d\n", flag, x, y);
  //assert(x >= y);
}

int main()
{
  run(0);
  return 0;
}
