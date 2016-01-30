void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
int __VERIFIER_nondet_int();


int ADD(int i, int j)
{
  int ret;
  if(i <= 0) ret = j;
  else
    {
      int b = i - 1;
      int c = j + 1;
      ret = ADD(b, c);
    }
  return ret;
}

int main(int argc, char* argv[])
{
  int x, y, result;
  x = __VERIFIER_nondet_int();
  y = __VERIFIER_nondet_int();

  result = ADD(x, y);

  __VERIFIER_assert(result == x + y);    
}

