#include <stdio.h>
#include <time.h>
#include <stdlib.h>
int main()
{
  int x, s, y;
  srand(time(NULL));
  x = rand() % 10;

  if (x < 0)
    return;
  
  s = 0;
  
  printf("[LOOP]\ts\tx\ty\n");
  while (s < x)
  {
    printf("[1]\t%d\t%d\t%d\n", s, x, y);
    s++;
  }
  printf("[1]\t%d\t%d\t%d\n", s, x, y);

  y = 0;

  while (y < s)
  {
    printf("[2]\t%d\t%d\t%d\n", s, x, y);
    y++;
  }
  printf("[2]\t%d\t%d\t%d\n", s, x, y);
  
  return 0;
}
