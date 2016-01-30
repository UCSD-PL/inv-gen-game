#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();


#define a (1)

int main() { 
  int i, sn=0;
  srand(time(NULL));
  int SIZE = 0;//rand();//__VERIFIER_nondet_int();

  printf("i\tsn\tSIZE\n");
  for(i=1; i<=SIZE; i++) {
    printf("%d\t%d\t%d\n", i, sn, SIZE);
    sn = sn + a;
  }
  printf("%d\t%d\t%d\n", i, sn, SIZE);
  __VERIFIER_assert(sn==SIZE*a || sn == 0);
}

