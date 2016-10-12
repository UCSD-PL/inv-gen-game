void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

void main()
{
  int x, N;
  x = 0;
  N = __VERIFIER_nondet_int();
  if (N < 0)
    return;

  while(x < N)
  {
    x = x + 1;
  }
  __VERIFIER_assert(x == N);    
  return;
}

