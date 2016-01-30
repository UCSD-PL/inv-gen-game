void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
int __VERIFIER_nondet_int();

int main(int argc, char* argv[])
{
  int n, x, r;
  n = 0;
  x = 0;
  r = __VERIFIER_nondet_int();

  while (r != 0)
  {
    n++;
    x += 2*n - 1;

    r = __VERIFIER_nondet_int();
  }

  __VERIFIER_assert(x == n*n);    
}

