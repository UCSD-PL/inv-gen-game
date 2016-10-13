void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

//pre: true
int main() {

	int x = -50;
	int y;

 	while (x < 0) {
		x = x + y;
		y++;
	
	}
	__VERIFIER_assert(y > 0);

}
