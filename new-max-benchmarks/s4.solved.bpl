procedure main() {
  var i,j,k: int;
  j := 0;
  i := 0;
  while (j < 1000)
invariant (i == i);
//invariant (i == k);
invariant (j == j);
//invariant (i == 0);
//invariant ((0 <= i) && (i <= 63));
//invariant (i <= 0);
//invariant (i == 0);
//invariant (i >= 0);
//invariant (i >= 0);
//invariant (i == 0);
//invariant ((i == 0) || (i == 1));
invariant ((i mod 2) == 0);
//invariant ((j == 0) || (j == 2));
//invariant ((0 <= j) && (j <= 63));
//invariant (j <= 2);
invariant ((j mod 2) == 0);
invariant (j >= 0);
invariant (j >= 0);
//invariant ((j == 0) || (j == 2));
invariant ((j mod 2) == 0);
//invariant (i == (i * i));
//invariant (i == (i * i));
invariant ((((0 * i) + (0 * i)) + 0) == 0);
//invariant (i <= j);
invariant ((((0 * i) + (0 * j)) + 0) == 0);
//invariant ((((0 * j) + (0 * j)) + 0) == 0),18,((0 mod 2) == 0);
invariant ((((0 * i) + (0 * i)) + 0) == 0);
invariant ((((0 * i) + (0 * j)) + 0) == 0);
invariant ((i mod 2) == 0);
invariant (0 >= 0);
invariant ((((0 * 0) + (0 * 0)) + 0) == 0);
invariant ((0 <= 0) && (0 <= 63));
invariant ((0 == 0) || (0 == 1));
invariant (j == j);
invariant (0 <= j);
invariant (0 == 0);
invariant ((j mod 2) == 0);
invariant (j >= 0);
invariant ((((0 * 0) + (0 * j)) + 0) == 0);
invariant (0 <= 0);
invariant (i == i);
invariant (0 == (0 * 0));
invariant ((((0 * j) + (0 * j)) + 0) == 0);

  //invariant i == k*j && j mod 2 == 0 && j <= 1000;
  {
    i := i + 2* k;
    j := j + 2;
  }
  assert(i ==  k*1000);
}
