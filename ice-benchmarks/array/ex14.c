void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

int main() {

    	int x,y;
   	int a[10];
   	x=1;

   	while (x <= 10){
      		y=10-x;

		if(y < 0 || y >= 10)
			__VERIFIER_assert(0 == 1);

      		a[y] = -1;
      		x++;
	
   	}

   	return 1;

}
