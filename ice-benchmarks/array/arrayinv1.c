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

  for(i=0;i<SIZE;i++) {
       // assert {1;1} b0(menor, j, array[0]);
       m = __VERIFIER_nondet_int();
       if (m != 0 && m != 3)
         return;
       array[i] = m;
    }                       
    
    __VERIFIER_assert(array[4]==0 || array[4] == 3);    
}

