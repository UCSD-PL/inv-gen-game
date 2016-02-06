#include <stdio.h>

void run(int n)
{
 	int k=1;
 	int i=1;
 	int j=0;

 	printf("[LOOP]\ti\tj\tk\tn\n");
 
 	while(i<n) {
 		printf("[1]\t%d\t%d\t%d\t%d\n", i, j, k, n);
  	j=0;

  	while(j<i) {
  		printf("[2]\t%d\t%d\t%d\t%d\n", i, j, k, n);
    	k += (i-j);
    	j++;
  	}
  	printf("[2]\t%d\t%d\t%d\t%d\n", i, j, k, n);
  	i++;
 	}
 	printf("[1]\t%d\t%d\t%d\t%d\n", i, j, k, n);
 	//static_assert(k>=n);
}

int main()
{
	run(4);
	return 0;
}