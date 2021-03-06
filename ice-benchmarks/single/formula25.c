/*//DIMO: Replaced with __tmp_assert in dummy.h
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
*/

int __VERIFIER_nondet_int();

main()
{
  int x1,x2,x3,x4;
  int x1p,x2p,x3p,x4p, input;

  x1 = x2 = x3 = 0; x4 = -1;
  input = __VERIFIER_nondet_int();
  while(input)
  {
    x1p = __VERIFIER_nondet_int();
    x2p = __VERIFIER_nondet_int();
    x3p = __VERIFIER_nondet_int();
    x4p = __VERIFIER_nondet_int();

    if (x1p <= 0 && x1p >= x4p + 1 && x2p == x3p && (x4p >= 0 || x4p <= x3p))
    {
	x1 = x1p;
	x2 = x2p;
	x3 = x3p;
	x4 = x4p;
    }
    input = __VERIFIER_nondet_int();
  }
  __VERIFIER_assert(x1 <= 0 && x1 >= x4 + 1 && x2 == x3 && (x4 >= 0 || x4 <= x3));
}

