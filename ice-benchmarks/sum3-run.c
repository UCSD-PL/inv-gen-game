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

int main() { 
  int sn=0;
  unsigned int loop1, n1;

  srand(time(NULL));
  loop1 = rand();
  n1 = rand();

  unsigned int x=0;

  printf("loop1\tn1\tsn\tx\n");

  while(1){
    printf("%d\t%d\t%d\t%d\n", loop1, n1, sn, x);
    sn = sn + 1;
    x++;
    __VERIFIER_assert(sn==x*1 || sn == 0);
  }
  printf("%d\t%d\t%d\t%d\n", loop1, n1, sn, x);
}

