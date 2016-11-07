implementation main()
{
  var N_LIN: int;
  var N_COL: int;
  var j: int;
  var k: int;
  var maior: int;
  var x: int;
  var matriz: [int][int]int;


  anon0:
    assume N_LIN >= 0 && N_COL >= 0 && j >= 0 && k >= 0;
    N_LIN := 1;
    N_COL := 1;
    havoc maior;
    j := 0;
    goto anon7_LoopHead;

  anon7_LoopHead:
    goto anon7_LoopDone, anon7_LoopBody;

  anon7_LoopBody:
    assume {:partition} j < N_COL;
    k := 0;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume {:partition} k < N_LIN;
    assert matriz[0][0] <= maior || (j == 0 && k == 0);
    havoc x;
    matriz[j][k] := x;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} maior > matriz[j][k];
    goto anon4;

  anon4:
    k := k + 1;
    goto anon8_LoopHead;

  anon9_Then:
    assume {:partition} matriz[j][k] >= maior;
    maior := matriz[j][k];
    goto anon4;

  anon8_LoopDone:
    assume {:partition} N_LIN <= k;
    j := j + 1;
    goto anon7_LoopHead;

  anon7_LoopDone:
    assume {:partition} N_COL <= j;
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} maior >= matriz[0][0];
    return;

  anon10_Then:
    assume {:partition} matriz[0][0] > maior;
    goto ERROR;

  ERROR:
    goto ERROR;
}

