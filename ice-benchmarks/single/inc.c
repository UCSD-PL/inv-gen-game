void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

main()
{
  int x, m;
  x = 0;
  while(x < 100)
  {
    m = __VERIFIER_nondet_int();
    x = x + 1;
  }
  __VERIFIER_assert(x == 100);    
}

