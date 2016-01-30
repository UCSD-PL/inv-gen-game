#include <stdio.h>
#include <time.h>
#include <stdlib.h>

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
  r = __VERIFIER_nondet_int();

  printf("n\tx\tr\n");
  while (r != 0)
  {
    printf("%d\t%d\t%d\n", n, x, r);
    n++;
    x += 2*n - 1;

    --r;//r = VERIFIER_nondet_int();
  }
  printf("%d\t%d\t%d\n", n, x, r);

  __VERIFIER_assert(x == n*n);    
}

