#include <assert.h>
#include <stdio.h>

int unknown1();
int unknown2();
int unknown3();
int unknown4();
void static_assert(int x) {}
void assume(int x) {}

/*
 * From "Simplifying Loop Invariant Generation using Splitter Predicates", Sharma et al. CAV'11
 */


void run(int n, int m)
{
  assume(n>=0);
  assume(m>=0);
  assume(m<n);
  int x=0; 
  int y=m;
  while(x<n) {
    printf("n = %d m = %d x = %d y = %d\n", n, m, x, y);
    x++;
    if(x>m) y++;
  }
  static_assert(y==n);
}

void main() {
  run(7, 3);
}


