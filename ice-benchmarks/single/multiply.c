void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
int __VERIFIER_nondet_int();

main()
{

  unsigned int x = __VERIFIER_nondet_int();
  unsigned int y = __VERIFIER_nondet_int();

  int s = 0;

  if (x < 0) return;

  for(int j = 0; j < x; j++)
  {
    // invariant: s == y*j and j <= x
    s = s + y;
  }
  __VERIFIER_assert(s == x*y);    
}

