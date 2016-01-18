//#include <assert.h>
#include <stdio.h>

int static_assert(int x) {}

void run(int flag, int u1, int u2)
{
  int t = 0;
  int s = 0;
  int a = 0;
  int b = 0;
  
  while(u1 != 0){
    printf("INSIDE FIRST: t = %d\ts = %d\ta = %d\tb = %d\tu1 = %d\tu2 = %d\tflag = %d\n", t, s, a, b, u1, u2, flag);
    a++;
    b++;
    s+=a;
    t+=b;
    if(flag){
      t+=a;
    }
    u1--;
  }
  printf("OUTSIDE FIRST: t = %d\ts = %d\ta = %d\tb = %d\tu1 = %d\tu2 = %d\tflag = %d\n", t, s, a, b, u1, u2, flag);
  
  //2s >= t
  
  int x = 1;
  if(flag){
    x = t-2*s+2;
  }
  //x <= 2
  int y = 0;
  
  while(y<=x){
      printf("INSIDE SECOND: t = %d\ts = %d\ta = %d\tb = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\tflag = %d\n", t, s, a, b, x, y, u1, u2, flag);
    if(u2) 
       y++;
    else 
       y+=2;
  }
  printf("OUTSIDE SECOND: t = %d\ts = %d\ta = %d\tb = %d\tx = %d\ty = %d\tu1 = %d\tu2 = %d\tflag = %d\n", t, s, a, b, x, y, u1, u2, flag);
  
  static_assert(y<=4);
}

int main()
{
    run(1, 5, 0);
    return 0;
}


/*
run(0,5,0):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 0  flag = 0
INSIDE FIRST: t = 1 s = 1 a = 1 b = 1 u1 = 4  u2 = 0  flag = 0
INSIDE FIRST: t = 3 s = 3 a = 2 b = 2 u1 = 3  u2 = 0  flag = 0
INSIDE FIRST: t = 6 s = 6 a = 3 b = 3 u1 = 2  u2 = 0  flag = 0
INSIDE FIRST: t = 10  s = 10  a = 4 b = 4 u1 = 1  u2 = 0  flag = 0
OUTSIDE FIRST: t = 15 s = 15  a = 5 b = 5 u1 = 0  u2 = 0  flag = 0
INSIDE SECOND: t = 15 s = 15  a = 5 b = 5 x = 1 y = 0 u1 = 0  u2 = 0  flag = 0
OUTSIDE SECOND: t = 15  s = 15  a = 5 b = 5 x = 1 y = 2 u1 = 0  u2 = 0  flag = 0

t >= 0, s >= 0, a >= 0, b >= 0, u1 <= 5, u1 >= 0, u2 == 0, flag == 0, t == s, t >= a, t >= b,
s >= a, s >= b, a == b, x == 1, y <= 2, y%2 == 0

*/

/*
run(0,5,1):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 1  flag = 0
INSIDE FIRST: t = 1 s = 1 a = 1 b = 1 u1 = 4  u2 = 1  flag = 0
INSIDE FIRST: t = 3 s = 3 a = 2 b = 2 u1 = 3  u2 = 1  flag = 0
INSIDE FIRST: t = 6 s = 6 a = 3 b = 3 u1 = 2  u2 = 1  flag = 0
INSIDE FIRST: t = 10  s = 10  a = 4 b = 4 u1 = 1  u2 = 1  flag = 0
OUTSIDE FIRST: t = 15 s = 15  a = 5 b = 5 u1 = 0  u2 = 1  flag = 0
INSIDE SECOND: t = 15 s = 15  a = 5 b = 5 x = 1 y = 0 u1 = 0  u2 = 1  flag = 0
INSIDE SECOND: t = 15 s = 15  a = 5 b = 5 x = 1 y = 1 u1 = 0  u2 = 1  flag = 0
OUTSIDE SECOND: t = 15  s = 15  a = 5 b = 5 x = 1 y = 2 u1 = 0  u2 = 1  flag = 0
*/

/*
run(0,5,2):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 2  flag = 0
INSIDE FIRST: t = 1 s = 1 a = 1 b = 1 u1 = 4  u2 = 2  flag = 0
INSIDE FIRST: t = 3 s = 3 a = 2 b = 2 u1 = 3  u2 = 2  flag = 0
INSIDE FIRST: t = 6 s = 6 a = 3 b = 3 u1 = 2  u2 = 2  flag = 0
INSIDE FIRST: t = 10  s = 10  a = 4 b = 4 u1 = 1  u2 = 2  flag = 0
OUTSIDE FIRST: t = 15 s = 15  a = 5 b = 5 u1 = 0  u2 = 2  flag = 0
INSIDE SECOND: t = 15 s = 15  a = 5 b = 5 x = 1 y = 0 u1 = 0  u2 = 2  flag = 0
INSIDE SECOND: t = 15 s = 15  a = 5 b = 5 x = 1 y = 1 u1 = 0  u2 = 2  flag = 0
OUTSIDE SECOND: t = 15  s = 15  a = 5 b = 5 x = 1 y = 2 u1 = 0  u2 = 2  flag = 0
*/

/*
run(1,5,2):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 2  flag = 1
INSIDE FIRST: t = 2 s = 1 a = 1 b = 1 u1 = 4  u2 = 2  flag = 1
INSIDE FIRST: t = 6 s = 3 a = 2 b = 2 u1 = 3  u2 = 2  flag = 1
INSIDE FIRST: t = 12  s = 6 a = 3 b = 3 u1 = 2  u2 = 2  flag = 1
INSIDE FIRST: t = 20  s = 10  a = 4 b = 4 u1 = 1  u2 = 2  flag = 1
OUTSIDE FIRST: t = 30 s = 15  a = 5 b = 5 u1 = 0  u2 = 2  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 0 u1 = 0  u2 = 2  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 1 u1 = 0  u2 = 2  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 2 u1 = 0  u2 = 2  flag = 1
OUTSIDE SECOND: t = 30  s = 15  a = 5 b = 5 x = 2 y = 3 u1 = 0  u2 = 2  flag = 1
*/

/*
run (1,5,1):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 1  flag = 1
INSIDE FIRST: t = 2 s = 1 a = 1 b = 1 u1 = 4  u2 = 1  flag = 1
INSIDE FIRST: t = 6 s = 3 a = 2 b = 2 u1 = 3  u2 = 1  flag = 1
INSIDE FIRST: t = 12  s = 6 a = 3 b = 3 u1 = 2  u2 = 1  flag = 1
INSIDE FIRST: t = 20  s = 10  a = 4 b = 4 u1 = 1  u2 = 1  flag = 1
OUTSIDE FIRST: t = 30 s = 15  a = 5 b = 5 u1 = 0  u2 = 1  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 0 u1 = 0  u2 = 1  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 1 u1 = 0  u2 = 1  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 2 u1 = 0  u2 = 1  flag = 1
OUTSIDE SECOND: t = 30  s = 15  a = 5 b = 5 x = 2 y = 3 u1 = 0  u2 = 1  flag = 1
*/

/*
run(1,5,0):

INSIDE FIRST: t = 0 s = 0 a = 0 b = 0 u1 = 5  u2 = 0  flag = 1
INSIDE FIRST: t = 2 s = 1 a = 1 b = 1 u1 = 4  u2 = 0  flag = 1
INSIDE FIRST: t = 6 s = 3 a = 2 b = 2 u1 = 3  u2 = 0  flag = 1
INSIDE FIRST: t = 12  s = 6 a = 3 b = 3 u1 = 2  u2 = 0  flag = 1
INSIDE FIRST: t = 20  s = 10  a = 4 b = 4 u1 = 1  u2 = 0  flag = 1
OUTSIDE FIRST: t = 30 s = 15  a = 5 b = 5 u1 = 0  u2 = 0  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 0 u1 = 0  u2 = 0  flag = 1
INSIDE SECOND: t = 30 s = 15  a = 5 b = 5 x = 2 y = 2 u1 = 0  u2 = 0  flag = 1
OUTSIDE SECOND: t = 30  s = 15  a = 5 b = 5 x = 2 y = 4 u1 = 0  u2 = 0  flag = 1
*/