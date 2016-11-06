// ../dilig-benchmarks/single/11.c
void main()
{
  int j=0;
  int i;
  int x=100;


  for (i =0; i< x ; i++){
    j = j + 2;
  }

  static_assert(j == 2*x);
}
