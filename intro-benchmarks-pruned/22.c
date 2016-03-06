/* 02-square */

#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main(int argc, char* argv[])
{
  int n, x, r;
  n = 0;
  x = 0;
  r = 5;

  while (r != 0)
  {
    trace(0, "n=%dx=%dr=%d", (int32_t)n, (int32_t)x, (int32_t)r);
    n++;
    x += 2*n - 1;
    --r;
  }
  trace(0, "n=%dx=%dr=%d", (int32_t)n, (int32_t)x, (int32_t)r);
  return 0;
}

