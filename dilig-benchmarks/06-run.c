//#include <assert.h>
#include <stdio.h>

void static_assert(int x) {}

void run(int u1, int u2)
{
  int w = 1;
  int z = 0;
  int x = 0;
  int y =0;

  while(u1!=0){
    printf("INSIDE FIRST:\tw = %d\tz = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\n", w, z, x, y, u1, u2);
    while(u2!=0){
      printf("INSIDE SECOND:\tw = %d\tz = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\n", w, z, x, y, u1, u2);
      if(w%2 == 1) x++;
      if(z%2==0) y++;
      u2--;
    }
    printf("OUTSIDE SECOND:\tw = %d\tz = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\n", w, z, x, y, u1, u2);
    z=x+y;
    w=z+1;
    u1--;
  }
  printf("OUTSIDE FIRST:\tw = %d\tz = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\n", w, z, x, y, u1, u2);
  
  static_assert(x==y);
}

int main()
{
  run(10,10);
  return 0;
}

/*
Accepted by Boogie: w >= 1, z >= 0, x >= 0, y >= 0, w == z+1, z <= x+y, (z > 0) ==> (z = x+y)

Not accepted by Boogie: (u2 == 0) ==> ((w != 1) && (z != 0)), w%2 == 1, z%2 == 0

INSIDE FIRST:   w = 1   z = 0   x = 0   y = 0   u1 = 10 u2 = 10
INSIDE SECOND:  w = 1   z = 0   x = 0   y = 0   u1 = 10 u2 = 10
INSIDE SECOND:  w = 1   z = 0   x = 1   y = 1   u1 = 10 u2 = 9
INSIDE SECOND:  w = 1   z = 0   x = 2   y = 2   u1 = 10 u2 = 8
INSIDE SECOND:  w = 1   z = 0   x = 3   y = 3   u1 = 10 u2 = 7
INSIDE SECOND:  w = 1   z = 0   x = 4   y = 4   u1 = 10 u2 = 6
INSIDE SECOND:  w = 1   z = 0   x = 5   y = 5   u1 = 10 u2 = 5
INSIDE SECOND:  w = 1   z = 0   x = 6   y = 6   u1 = 10 u2 = 4
INSIDE SECOND:  w = 1   z = 0   x = 7   y = 7   u1 = 10 u2 = 3
INSIDE SECOND:  w = 1   z = 0   x = 8   y = 8   u1 = 10 u2 = 2
INSIDE SECOND:  w = 1   z = 0   x = 9   y = 9   u1 = 10 u2 = 1
OUTSIDE SECOND: w = 1   z = 0   x = 10  y = 10  u1 = 10 u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 9  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 9  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 8  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 8  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 7  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 7  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 6  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 6  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 5  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 5  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 4  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 4  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 3  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 3  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 2  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 2  u2 = 0
INSIDE FIRST:   w = 21  z = 20  x = 10  y = 10  u1 = 1  u2 = 0
OUTSIDE SECOND: w = 21  z = 20  x = 10  y = 10  u1 = 1  u2 = 0
OUTSIDE FIRST:  w = 21  z = 20  x = 10  y = 10  u1 = 0  u2 = 0
*/