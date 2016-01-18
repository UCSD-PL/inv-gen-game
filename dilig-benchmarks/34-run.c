#include <assert.h>
#include <stdio.h>

void static_assert(int x) {}
void assume(int x) {}

void run(int n)
{
  int x=0;
  int y=0;
  int i=0;
  int m=10;
  
 
  while(i<n) {
    printf("i = %d\tx = %d\ty = %d\tm = %d\n", i, x, y, m);
    i++;
    x++;
    if(i%2 == 0) y++;
  }
  printf("i = %d\tx = %d\ty = %d\tm = %d\n", i, x, y, m);
  

  if(i==m) static_assert(x==2*y);
}

int main() {
    run(10);
    /* i >= 0, i <= n, x >= 0, x == i, y == x/2, m == 10 */
    return 0;
}