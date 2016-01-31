#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 int n = 5;
 int i,j;
 for (i = 0; i < n; i++) {
   j =i * i;
   trace(0, "i=%dj=%d", (int32_t)i, (int32_t)j);
 }
 trace(0, "i=%dj=%d", (int32_t)i, (int32_t)j);
 return 0;
}

