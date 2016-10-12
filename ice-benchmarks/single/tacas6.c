void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

void foo(int i, int j) {

	int x = i;
	int y = j;

 	while (x != 0) {
		x--;
		y--;
	}

	if (i == j)
		__VERIFIER_assert(y == 0);

}

int main()
{
  int i, j;
  foo(i, j);
}
