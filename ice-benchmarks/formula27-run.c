#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main()
{
  int x1,x2,x3,x4,x5;
  int x1p,x2p,x3p,x4p,x5p, input;

  x1 = x2 = x3 = x4 = x5 = 0;

  srand(time(NULL));
 
  input = 10;//rand();

  printf("x1\tx1p\tx2\tx2p\tx3\tx3p\tx4\tx4p\tx5\tx5p\n");
  
  while(input)
  {
    printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n", x1, x1p, x2, x2p, x3, x3p, x4, x4p, x5, x5p);
    x1p = rand();
    x2p = rand();
    x3p = rand();
    x4p = rand();
    x5p = rand();

    if (0 <= x1p && x1p <= x4p + 1 && x2p == x3p && (x2p <= -1 || x4p <= x2p + 2) && x5p == 0)
    {
      x1 = x1p;
      x2 = x2p;
      x3 = x3p;
      x4 = x4p;
      x5 = x5p;
    }
    input--;// = rand();
  }
  printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n", x1, x1p, x2, x2p, x3, x3p, x4, x4p, x5, x5p);
  //__VERIFIER_assert(0 <= x1 && x1 <= x4 + 1 && x2 == x3 && (x2 <= -1 || x4 <= x2 + 2) && x5 == 0);
}
