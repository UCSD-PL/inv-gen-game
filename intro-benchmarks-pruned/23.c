/* 03-add */

#include <assert.h>
#include <stdio.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int ADD(int i, int j)
{
  int ret;
  if(i <= 0) ret = j;
  else
  {
    int b = i - 1;
    int c = j + 1;
    ret = ADD(b, c);
  }
  trace(0, "i=%dj=%dret=%d", (int32_t)i, (int32_t)j, (int32_t)ret);
  return ret;
}

int main(int argc, char* argv[])
{
  int x, y, result;
  x = 5;
  y = 5;
  result = ADD(x, y);
  return 0;
}
