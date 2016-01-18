#include <assert.h>
#include <stdio.h>

void static_assert(int x) {}

void run(int k)
{
	int i = 1;
	int j = 0;
	int z = i-j;
	int x = 0;
	int y = 0;
	int w = 0;

	while(k--) 
	{
        printf("i = %d\tj = %d\tz = %d\tx = %d\ty = %d\tw = %d\t\n", i, j, z, x, y, w);
		z+=x+y+w;
		y++;
		if(z%2==1) 
		  x++;
		w+=2; 
	}
    printf("i = %d\tj = %d\tz = %d\tx = %d\ty = %d\tw = %d\t\n", i, j, z, x, y, w);

	static_assert(x==y);
}

int main()
{
	run(10);
	return 0;
}

/*
Accepted by Boogie: i == 1 && j == 0 && i == j + 1 && x >= 0 && y >= 0 && w >= 0 && (w - int(w/2) * 2 == 0) && w == 2*y && z >= i && z >= j && z >= x && z >= y && (w >= 4 ==> z >= w) && z >= i+j && z >= i-j && z >= x+j && z >= y+j;

Not accepted: x == y, w == 2*x, z%2 != 0, (w <= 2 ==> z < w)

i = 1   j = 0   z = 1   x = 0   y = 0   w = 0                                                                                                                                                                                     
i = 1   j = 0   z = 1   x = 1   y = 1   w = 2                                                                                                                                                                                     
i = 1   j = 0   z = 5   x = 2   y = 2   w = 4                                                                                                                                                                                     
i = 1   j = 0   z = 13  x = 3   y = 3   w = 6                                                                                                                                                                                     
i = 1   j = 0   z = 25  x = 4   y = 4   w = 8                                                                                                                                                                                     
i = 1   j = 0   z = 41  x = 5   y = 5   w = 10                                                                                                                                                                                    
i = 1   j = 0   z = 61  x = 6   y = 6   w = 12                                                                                                                                                                                    
i = 1   j = 0   z = 85  x = 7   y = 7   w = 14                                                                                                                                                                                    
i = 1   j = 0   z = 113 x = 8   y = 8   w = 16                                                                                                                                                                                    
i = 1   j = 0   z = 145 x = 9   y = 9   w = 18                                                                                                                                                                                    
i = 1   j = 0   z = 181 x = 10  y = 10  w = 20
*/
