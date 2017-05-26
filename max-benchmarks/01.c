#include <assert.h>
int unknown1();
int unknown2();
int unknown3();
int unknown4();

/*
 * Motivation: curious to see if other tools can handle this.
 * This is a really simple benchmark, I'm assuming we have something 
 * similar already?
 */ 

void main()
{
 int j=0; int i=0;
 while(j<1000) {
   i = i + k;
   j = j + 1;
 }
 static_assert(i==k*j);
}

