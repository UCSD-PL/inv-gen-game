#include <assert.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
 int n = 5;
 int i;
 for (i = 0; i < n; i++) {
   trace(0, "k=%d", 9);
 }
 //trace(0, "i=%d", 1);
 return 0;
}

