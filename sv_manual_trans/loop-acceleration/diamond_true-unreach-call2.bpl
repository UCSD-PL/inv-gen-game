// c/loop-acceleration/diamond_true-unreach-call2.c

procedure main() {
  var x, y: int;
  x := 0;
  //unsigned int y = __VERIFIER_nondet_uint();

  while (x < 99) 
  invariant (y mod 2 == 0 ==> x mod 2 == 0) && (y mod 2 == 1 ==> x <= 99);
  {
    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x + 1;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 2;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x + 2;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 2;
    }
  
    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 2;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 4;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x + 4;
    }

    if (y mod 2 == 0){
      x := x + 2;
    } else {
      x := x + 2;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 4;
    }

    if (y mod 2 == 0) {
      x := x + 2;
    } else {
      x := x - 4;
    }
  }
  assert((x mod 2) == (y mod 2));
}

