/*//DIMO: Replaced with __tmp_assert in dummy.h
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
*/
unsigned int __VERIFIER_nondet_uint();

int main()
{
  unsigned int n = __VERIFIER_nondet_uint();
  unsigned int x=n, y=0;
  while(x>0)
  {
    x--;
    y++;
  }
  __VERIFIER_assert(y==n);
}

