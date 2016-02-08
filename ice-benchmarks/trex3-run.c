#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main()
{
  srand(time(NULL));

  unsigned int x1=rand()%10;
  unsigned int x2=rand()%10;
  unsigned int x3=rand()%10;

  unsigned int d1=1, d2=1, d3=1;
  
  _Bool c1=(rand() % 2 == 0), c2=(rand() % 2 == 0);
  

  printf("c1\tc2\td1\td2\td3\tx1\tx2\tx3\n");
  while(x1>0 && x2>0 && x3>0)
  {
    printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", c1, c2, d1, d2, d3, x1, x2, x3);
    if (c1) x1=x1-d1;
    else if (c2) x2=x2-d2;
    else x3=x3-d3;
    c1=(rand() % 2 == 0);
    c2=(rand() % 2 == 0);
  }
  printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", c1, c2, d1, d2, d3, x1, x2, x3);

  //assert(x1==0 || x2==0 || x3==0);
  return 0;
}
