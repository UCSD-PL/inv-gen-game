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
  x = 100;
  while(x > 0)
  {
    m = __VERIFIER_nondet_int();
    x = x - 1;
  }
  __VERIFIER_assert(x == 0);    
}

