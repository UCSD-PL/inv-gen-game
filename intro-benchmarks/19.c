#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 int n = 5;
 int i,j,k;
 for (i = 0, j=0, k=n; i < n; i++, j++, k--) {
   trace(0, "i=%dj=%dk=%d", (int32_t)i, (int32_t)j, (int32_t)k);
 }
 trace(0, "i=%dj=%dk=%d", (int32_t)i, (int32_t)j, (int32_t)k);
 return 0;
}

