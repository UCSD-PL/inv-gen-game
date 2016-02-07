#include <stdio.h>

void run(int* a, int size)
{
  int d, i;
  int b[size];

  d = a[0];
  i = 1;
  
  printf("size\td\ti\n");
  while(i < size)
  {
    printf("%d\t%d\t%d\n", size, d, i);
    b[i-1] = a[i] - d;
    d = a[i];
    i = i + 1;
  }
  printf("%d\t%d\t%d\n", size, d, i);

  //print a
  printf("\na: ");
  for(i = 0; i < size; i++)
    printf("%d\t", a[i]);

  //print b
  printf("\nb: ");
  for(i = 0; i < size; i++)
    printf("%d\t", b[i]);

  printf("\n");
}

int main()
{
  int array[5] = {-10, 0, 2, 3, 3};
  run(array, 5);
  return 0;
}

/*
size    d       i                                                                                                                                                                                                                 
5       0       1                                                                                                                                                                                                                 
5       1       2                                                                                                                                                                                                                 
5       2       3                                                                                                                                                                                                                 
5       3       4                                                                                                                                                                                                                 
5       3       5                                                                                                                                                                                                                 
                                                                                                                                                                                                                                  
a: -10  0       2       3       3                                                                                                                                                                                                 
b: 11   2       1       0       0
*/