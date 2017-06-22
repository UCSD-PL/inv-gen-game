procedure main() {
  var i,j,k,z: int;
  j := 0;
  i := 0;
  z := 0;
  while (j < 1000)
invariant (i == i);
//invariant (i == z);
invariant (j == j);
//invariant ((i == 0) || (i == 5));
//invariant ((0 <= i) && (i <= 63));
//invariant (i <= 5);
invariant ((i mod 5) == 0);
invariant (i >= 0);
invariant (i >= 0);
//invariant ((i == 0) || (i == 5));
//invariant ((j == 0) || (j == 1));
//invariant ((0 <= j) && (j <= 63));
//invariant (j <= 1);
invariant (j >= 0);
invariant (j >= 0);
//invariant ((j == 0) || (j == 1));
//invariant ((j == 0) || (j == 1));
invariant ((((0 * i) + (0 * i)) + 0) == 0);
invariant ((i == 0) ==> (j == 0));
invariant ((j == 0) ==> (i == 0));
invariant (i >= j);
invariant ((((0 * i) + (0 * j)) + 0) == 0);
//invariant (j == (j * j));
//invariant (j == (j * j));
//invariant ((((0 * j) + (0 * j)) + 0) == 0),11,((((0 * i) + (0 * i)) + 0) == 0);
invariant ((i mod 5) == 0);
invariant ((((0 * i) + (0 * j)) + 0) == 0);
invariant (i >= 0);
invariant (i >= j);
invariant ((i == 0) ==> (j == 0));
invariant ((j == 0) ==> (i == 0));
invariant (i == i);
invariant (j == j);
invariant (j >= 0);
invariant ((((0 * j) + (0 * j)) + 0) == 0);
  //invariant i == 5*j && i == z;
  {
    i := i + 5;
    j := j + 1;
    z := 5*j;
  }
  assert(i == z);
}
