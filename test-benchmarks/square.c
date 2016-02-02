#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int()
{
  srand(time(NULL));
  return rand() % 20;
}

int main(int argc, char* argv[])
{
  int n, x, r;
  n = 0;
  x = 0;
  srand(time(NULL));
  //r = rand() % 10;//__VERIFIER_nondet_int();
  r = 5;

  //printf("n\tx\tr\n");
  while (r != 0)
  {
    trace(0, "n=%dx=%dr=%d", (int32_t)n, (int32_t)x, (int32_t)r);
    //printf("%d\t%d\t%d\n", n, x, r);
    n++;
    x += 2*n - 1;

    --r;//r = VERIFIER_nondet_int();
  }
  trace(0, "n=%dx=%dr=%d", (int32_t)n, (int32_t)x, (int32_t)r);
  //printf("%d\t%d\t%d\n", n, x, r);

  __VERIFIER_assert(x == n*n);    
  return 0;
}

