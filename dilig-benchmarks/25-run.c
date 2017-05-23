#include <assert.h>
#include <stdio.h>

int count1 = 0;
int count2 = 0;
int count3 = 0;
int count4 = 0;
int unknown1() { return ((++count1) % 7) != 0; }
int unknown2() { return ((++count2) % 7) != 0; }
int unknown3() { return ((++count3) % 7) != 0; }
int unknown4() { return ((++count4) % 7) != 0; }

void static_assert(int x) {}

void main()
{
  int x = 0;
  int y = 0;
  int i = 0;
  int j = 0;
  while(unknown1())
  {
    printf("1 x = %d y = %d i = %d j = %d\n", x, y, i, j);
    while(unknown2())
    {
      printf("2 x = %d y = %d i = %d j = %d\n", x, y, i, j);

       if(x==y)
          i++;
       else
          j++;
    }
    printf("2 x = %d y = %d i = %d j = %d\n", x, y, i, j);
    if(i>=j)
    {
       x++;
       y++;
    }
    else
       y++;
  }
  printf("1 x = %d y = %d i = %d j = %d\n", x, y, i, j);

  static_assert(i>=j);
}
