#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 int n = 4;
 int k,l;
 for (k = 0, l=0; k < n; k++,l+=3) {
   trace(0, "k=%dl=%d", (int32_t)1, (int32_t)2);
 }
// trace(0, "k=%dl=%d", (int32_t)k, (int32_t)l);
 return 0;
}

