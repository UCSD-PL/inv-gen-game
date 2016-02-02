#include <assert.h>
#include <stdio.h>
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
  //printf("i = %d\tj = %d\tret = %d\n", i, j, ret);
  return ret;
}

int main(int argc, char* argv[])
{
  int x, y, result;
  x = 5;
  y = 5;
  result = ADD(x, y);
}

/* Sample output:
i = 0   j = 10  ret = 10                                                                                                                                                             
i = 1   j = 9   ret = 10                                                                                                                                                             
i = 2   j = 8   ret = 10                                                                                                                                                             
i = 3   j = 7   ret = 10                                                                                                                                                             
i = 4   j = 6   ret = 10                                                                                                                                                             
i = 5   j = 5   ret = 10
*/
