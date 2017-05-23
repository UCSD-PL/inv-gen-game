#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

void main()
{
 int n = 4;
 int k,l;
 for (k = 0, l=0; k < n; k++,l+=3) {
   trace(0, "k=%dl=%d", (int32_t)k, (int32_t)l);
 }
 trace(0, "k=%dl=%d", (int32_t)k, (int32_t)l);
}

