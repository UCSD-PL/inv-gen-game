#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int r;

int main()
{
  unsigned int x = 5; 
  unsigned int y = 4;

  int s = 0, j;

  if (x < 0) return -1;

  for(j = 0; j < x; j++)
  {
    trace(0, "x=%dy=%ds=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)s, (int32_t)j);
    s = s + y;
  }
  trace(0, "x=%dy=%ds=%dj=%d", (int32_t)x, (int32_t)y, (int32_t)s, (int32_t)j);
  return 0;
}

