#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
void trace(int loopID, char *fmt, ...);

int r;

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int(int n)
{
  srand(time(NULL));
  r = rand() % n;
  return r;
}

void main()
{
  srand(time(NULL));
  unsigned int x = rand() % 10;//__VERIFIER_nondet_int(10);
  unsigned int y = rand() % 20;//__VERIFIER_nondet_int(20);

  int s = 0;

  if (x < 0) return;

  //printf("x\ty\ts\n");
  for(int j = 0; j < x; j++)
  {
    trace(0, "x=%dy=%ds=%d", (int32_t)x, (int32_t)y, (int32_t)s);
    //printf("%d\t%d\t%d\n", x, y, s);
    // invariant: s == y*j and j <= x
    s = s + y;
  }
  //printf("%d\t%d\t%d\n", x, y, s);
  trace(0, "x=%dy=%ds=%d", (int32_t)x, (int32_t)y, (int32_t)s);
  //__VERIFIER_assert(s == x*y);    
}

