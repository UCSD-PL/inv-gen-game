#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

void main()
{
 int n = 4;
 int i,j;
 for (i = 0, j=1; i < n; i++,j++) {
   trace(0, "i=%dj=%d", (int32_t)i, (int32_t)j);
 }
 trace(0, "i=%dj=%d", (int32_t)i, (int32_t)j);
}

