#include <stdio.h>
/*
 * "nested4.c" from InvGen benchmark suite
 */


void run(int n, int l) {
  int i,k;

  //assume(l>0);

  printf("[Loop]\tk\ti\tn\tl\n");

  for (k=1;k<n;k++){
  	printf("[1]\t%d\t%d\t%d\t%d\n", k, i, n, l);
    for (i=l;i<n;i++) {
      printf("[2]\t%d\t%d\t%d\t%d\n", k, i, n, l);
    }
    printf("[2]\t%d\t%d\t%d\t%d\n", k, i, n, l);
    for (i=l;i<n;i++) {
      printf("[3]\t%d\t%d\t%d\t%d\n", k, i, n, l);
      //static_assert(1<=i);
    }
    printf("[3]\t%d\t%d\t%d\t%d\n", k, i, n, l);
  }
  printf("[1]\t%d\t%d\t%d\t%d\n", k, i, n, l);
}

int main() {
	run(3, 3);
	return 0;
}