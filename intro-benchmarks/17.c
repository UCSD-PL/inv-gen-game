#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 int n = 5;
 int i;
 for (i = 0; i < n; i++) {
   trace(0, "n=%di=%d", (int32_t)n, (int32_t)i);
 }
 trace(0, "n=%di=%d", (int32_t)n, (int32_t)i);
 return 0;
}

