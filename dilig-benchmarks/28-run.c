#include <stdio.h>

void run(int ctr) {
  
  int x = 0;
  int y = 0;
  int n = 0;

  printf("[LOOP]\tctr\tn\tx\ty\n");
  while(ctr > 0) {
    printf("[1]\t%d\t%d\t%d\t%d\n", ctr, n, x, y);
    x++;
    y++;
    ctr--;
  }
  printf("[1]\t%d\t%d\t%d\t%d\n", ctr, n, x, y);
  
  while(x!=n) {
    printf("[2]\t%d\t%d\t%d\t%d\n", ctr, n, x, y);
    x--;
    y--;
  }
  printf("[2]\t%d\t%d\t%d\t%d\n", ctr, n, x, y);
  //static_assert(y==n);
}

int main() {
  run(5);
  return 0;
}