#include <assert.h>
#include <stdio.h>
#include <stdint.h>
void trace(int loopID, char *fmt, ...);

int main()
{
  int count = 5;
  int x = 1, y = 1, t1, t2;
  
  //printf("x\ty\tt1\tt2\n");

  while(count > 0) {
  	trace(0, "x=%dy=%dt1=%dt2=%d", (int32_t)x, (int32_t)y, (int32_t)t1, (int32_t)t2);
  	//printf("%d\t%d\t%d\t%d\n", x, y, t1, t2);
    t1 = x;
    t2 = y;
    x = t1+ t2;
    y = t1 + t2;
    count--;
  }
  
  return 0;
}

/*
Sample output:
x       y       t1      t2                                                                                                                                                           
1       1       334955456       0                                                                                                                                                    
2       2       1       1                                                                                                                                                            
4       4       2       2                                                                                                                                                            
8       8       4       4                                                                                                                                                            
16      16      8       8                                                                                                                                                            
32      32      16      16                                                                                                                                                           
64      64      32      32                                                                                                                                                           
128     128     64      64                                                                                                                                                           
256     256     128     128                                                                                                                                                          
512     512     256     256                                                                                                                                                          
1024    1024    512     512
*/
