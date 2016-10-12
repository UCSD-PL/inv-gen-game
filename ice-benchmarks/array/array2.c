void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

main()
{
  int SIZE;
  unsigned int j,k;
  int menor;
  SIZE = __VERIFIER_nondet_int();
  menor = __VERIFIER_nondet_int();
  int array[SIZE];

  //array = (int*)malloc(SIZE*sizeof(int));

  for(j=0;j<SIZE;j++) {
       array[j] = __VERIFIER_nondet_int();
       
       if(array[j]<=menor)
          menor = array[j];                          
    }                       
    
    __VERIFIER_assert(SIZE <= 0 || array[0]>=menor);    
}

