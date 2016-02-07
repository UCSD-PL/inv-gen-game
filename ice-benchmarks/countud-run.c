#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main()
{
  srand(time(NULL));
  unsigned int n = rand() % 10;
  unsigned int x=n, y=0;

  printf("n\tx\ty\n");
  while(x>0)
  {
    printf("%d\t%d\t%d\n", n, x, y);
    x--;
    y++;
  }
  printf("%d\t%d\t%d\n", n, x, y);
  //__VERIFIER_assert(y==n);
  return 0;
}
