/* dilig-01 */

#include <assert.h>
#include <stdio.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
  int count = 5;
  int x = 1, y = 1, t1, t2;
  
  while(count > 0) {
  	trace(0, "x=%dy=%dt1=%dt2=%d", (int32_t)x, (int32_t)y, (int32_t)t1, (int32_t)t2);
    t1 = x;
    t2 = y;
    x = t1+ t2;
    y = t1 + t2;
    count--;
  }
  return 0;
}
