#include <stdio.h>
#include <time.h>
#include <stdlib.h>

/*//DIMO: Replaced with __tmp_assert in dummy.h
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
*/

//#define a (2)

// DIMO: Ignore body
int __VERIFIER_nondet_int();
/*
{
	srand(time(NULL));
	return rand() % 20;
}
*/

int main() { 
  int i, n, sn=0;

  n=__VERIFIER_nondet_int();

  for(i=1; i<=n; i++) {
    sn = sn + 1;
  }
  __VERIFIER_assert(sn==n || sn == 0);
}

/*
i	n	sn
1	5	0
2	5	1
3	5	2
4	5	3
5	5	4
6	5	5
*/
