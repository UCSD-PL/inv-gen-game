#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main()
{
  unsigned int N_LIN=1;
  unsigned int N_COL=1;
  unsigned int j,k;
  int matriz[N_COL][N_LIN], maior;

  srand(time(NULL));

  maior = rand() % 100;//__VERIFIER_nondet_int();

  matriz[0][0] = rand() % 100;

  printf("[LOOP]\tj\tk\tmaior\tmatriz[0][0]\n");
  
  for(j=0;j<N_COL;j++)
  {
    //printf("[1]\t%d\t%d\t%d\t%d\n", j, k, maior, matriz[j][k]);
    for(k=0;k<N_LIN;k++)
    {
      printf("[2]\t%d\t%d\t%d\t%d\n", j, k, maior, matriz[j][k]);
      matriz[j][k] = rand() % 100;//__VERIFIER_nondet_int();

      if(matriz[j][k]>=maior)
        maior = matriz[j][k];
    }
    printf("[2]\t%d\t%d\t%d\t%d\n", j, k, maior, matriz[j][k]);
  }
  printf("[1]\t%d\t%d\t%d\t%d\n", j, k, maior, matriz[j][k]);

  if(!(matriz[0][0]<=maior))
  {
    ERROR:
    goto ERROR;
  }
}
