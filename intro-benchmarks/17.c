#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 trace(0, "k=%dl=%d", (int32_t)1, (int32_t)10);
 trace(0, "k=%dl=%d", (int32_t)5, (int32_t)5);
 trace(0, "k=%dl=%d", (int32_t)0, (int32_t)8);
 trace(0, "k=%dl=%d", (int32_t)4, (int32_t)15);
 return 0;
}

