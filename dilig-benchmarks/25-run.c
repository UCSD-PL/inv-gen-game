#include <assert.h>
#include <stdio.h>

int count1 = 0;
int count2 = 0;
int count3 = 0;
int count4 = 0;
int unknown1() { return ((++count1) % 5) != 0; }
int unknown2() { return ((++count2) % 5) != 0; }
int unknown3() { return ((++count3) % 5) != 0; }
int unknown4() { return ((++count4) % 5) != 0; }

void static_assert(int x) {}

void main()
{
  int x = 0;
  int y = 0;
  int i = 0;
  int j = 0;
  while(unknown1())
  {
    while(unknown2())
    {
      printf("x = %d y = %d i = %d j = %d\n", x, y, i, j);

       if(x==y)
          i++;
       else
          j++;
    }
    if(i>=j)
    {
       x++;
       y++;
    }
    else
       y++;
  }

  static_assert(i>=j);
}
