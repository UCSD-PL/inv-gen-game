void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
int __VERIFIER_nondet_int();

main()
{
  int x, s, y;

  x = __VERIFIER_nondet_int();
  if (x < 0)
    return;
  s = 0;
  while (s < x)
    s++;

  y = 0;
  while (y < s)
    y++;
  
  __VERIFIER_assert(y == x);    
}

