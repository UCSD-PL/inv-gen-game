void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
int __VERIFIER_nondet_int();

main()
{
  unsigned int SIZE;
  unsigned int i,m;  
  SIZE = __VERIFIER_nondet_int();
  if (SIZE < 10)
    return;

  int array[SIZE];
  m = array[0];
  for(i=0;i<SIZE;i++) {
       // assert {1;1} b0(menor, j, array[0]);
       if (array[i] <= m)
    	  m = array[i];
    }                       
    
    __VERIFIER_assert(m <= array[4]);    
}

