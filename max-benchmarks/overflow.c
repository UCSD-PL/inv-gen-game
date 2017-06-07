#include <assert.h>

/*
 * Motivation: Do different framework suppor 32 bit ints
 */ 

void main()
{
 int j=0; long i=0;
 while(i>=0) {
   i = i + 1;
   j = j + 1;
 }
 static_assert(i>0);
 static_assert(j>0);
}

