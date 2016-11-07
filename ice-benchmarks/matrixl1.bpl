procedure main()
{
  var N_LIN, N_COL, j, k, maior, x: int;
  var matriz: [int][int]int;
  
  assume (N_LIN >= 0) && (N_COL >= 0) && (j >= 0) && (k >= 0);
  
  N_LIN := 1;
  N_COL := 1;
  havoc maior;
  
  j := 0;
  while (j < N_COL)
  {
    k := 0;
    while(k < N_LIN)
    {
       assert(matriz[0][0] <= maior || (j == 0 && k == 0));
       havoc x;
       matriz[j][k] := x;
       if(matriz[j][k] >= maior)
       {
          maior := matriz[j][k];
       }
       k := k + 1;
    }
    j := j + 1;
  }

  if(matriz[0][0] > maior)
  {
    ERROR:
    goto ERROR;
  }
}
