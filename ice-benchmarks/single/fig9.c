void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();


//pre: true
int main() {

	int x, y;
	x = 0;
	y = 0;

	while(y >= 0) {

		y = y + x;
	
	}

	__VERIFIER_assert(0 == 1);

}
