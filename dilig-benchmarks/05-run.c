#include <stdio.h>

void run(int flag)
{

	int x = 0;
	int y = 0;

	int j = 0;
	int i = 0;

	int times = 10;
	int ctr = 0;

	printf("i\tj\tx\ty\n");

	while(ctr < times)
	{
	  printf("%d\t%d\t%d\t%d\n", i, j, x, y);
	  x++;
	  y++;
	  i+=x;
	  j+=y;
	  if(flag)  j+=1;
	  ctr++;
	}
	printf("%d\t%d\t%d\t%d\n", i, j, x, y);
	//static_assert(j>=i);
	
}

int main() {
	run(1);
	return 0;
}