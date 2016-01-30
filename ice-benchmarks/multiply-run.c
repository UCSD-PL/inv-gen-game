#include <stdio.h>
#include <time.h>
#include <stdlib.h>

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

  unsigned int x = __VERIFIER_nondet_int(10);
  unsigned int y = __VERIFIER_nondet_int(20);

  int s = 0;

  if (x < 0) return;

  printf("x\ty\ts\n");
  for(int j = 0; j < x; j++)
  {
    printf("%d\t%d\t%d\n", x, y, s);
    // invariant: s == y*j and j <= x
    s = s + y;
  }
  printf("%d\t%d\t%d\n", x, y, s);
  __VERIFIER_assert(s == x*y);    
}

