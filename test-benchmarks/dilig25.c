#include <assert.h>
#include <stdio.h>
#include <stdint.h>

int count1 = 0;
int count2 = 0;
int count3 = 0;
int count4 = 0;
int unknown1() { return ((++count1) % 7) != 0; }
int unknown2() { return ((++count2) % 7) != 0; }
int unknown3() { return ((++count3) % 7) != 0; }
int unknown4() { return ((++count4) % 7) != 0; }

int main()
{
  int x = 0;
  int y = 0;
  int i = 0;
  int j = 0;

  while(unknown1())
  {
    trace(0, "x=%dy=%di=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)i, (int32_t)j);
    while(unknown2())
    {
      trace(1, "x=%dy=%di=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)i, (int32_t)j);

       if(x==y)
          i++;
       else
          j++;
    }
    trace(1, "x=%dy=%di=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)i, (int32_t)j);
    if(i>=j)
    {
       x++;
       y++;
    }
    else
       y++;
  }
  trace(0, "x=%dy=%di=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)i, (int32_t)j);
  return 0;
}
