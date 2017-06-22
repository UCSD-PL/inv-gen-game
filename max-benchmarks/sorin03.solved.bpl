// Adaptation of Gauss benchmark, which we currently can't solve
// (well one person now solved it)
// I'm adding a new var j to see how this affects automated tools and humans
procedure main() {
  var n,s,i,j: int;
  assume(1 <= n && n <= 1000);
  s := 0;
  j := 0;
  i := 1;
  while (i <= n)

invariant (i == i);
invariant (j == j);
invariant (s == s);
invariant (n == n);
//invariant ((0 <= i) && (i <= 63));
invariant (i != 0);
//invariant (i <= 11);
invariant (i >= 0);
invariant (i >= 1);
//invariant (((((((((((i == 1) || (i == 2)) || (i == 3)) || (i == 4)) || (i == 5)) || (i == 6)) || (i == 7)) || (i == 8)) || (i == 9)) || (i == 10)) || (i == 11));
//invariant ((0 <= j) && (j <= 63));
//invariant (j <= 10);
invariant (j >= 0);
invariant (j >= 0);
//invariant (((((((((((((((((j == 0) || (j == 1)) || (j == 2)) || (j == 3)) || (j == 6)) || (j == 4)) || (j == 10)) || (j == 5)) || (j == 15)) || (j == 21)) || (j == 7)) || (j == 28)) || (j == 8)) || (j == 36)) || (j == 9)) || (j == 45)) || (j == 55));
//invariant ((0 <= s) && (s <= 63));
//invariant (s <= 55);
//invariant (s >= 0);
invariant (s >= 0);
//invariant (((((((((((((((((s == 0) || (s == 1)) || (s == 2)) || (s == 3)) || (s == 6)) || (s == 4)) || (s == 10)) || (s == 5)) || (s == 15)) || (s == 21)) || (s == 7)) || (s == 28)) || (s == 8)) || (s == 36)) || (s == 9)) || (s == 45)) || (s == 55));
//invariant (n == 10);
//invariant ((0 <= n) && (n <= 63));
invariant (n != 0);
//invariant (n <= 10);
invariant (n >= 0);
//invariant (n >= 10);
//invariant (n == 10);
//invariant ((n mod 2) == 0);
invariant ((i - i) == 0);
invariant (((i - j) - 1) == 0);
invariant (i > j);
invariant ((j - j) == 0);
invariant ((j == 0) ==> (s == 0));
invariant ((s == 0) ==> (j == 0));
invariant (j <= s);
invariant (j <= n);
invariant ((s - s) == 0);
//invariant ((((0 * n) + (0 * n)) + 0) == 0),32,((j - j) == 0);
invariant (j <= s);
invariant (((i - j) - 1) == 0);
invariant ((s - s) == 0);
invariant ((((0 * 10) + (0 * 10)) + 0) == 0);
invariant (10 == 10);
invariant (j <= n);
invariant (n <= n);
invariant (s == s);
invariant (n == n);
invariant (j == j);
invariant (n >= 0);
invariant (10 >= 0);
invariant (s >= 0);
invariant ((((0 * n) + (0 * n)) + 0) == 0);
invariant (10 <= 10);
invariant (i > j);
invariant (i >= 0);
invariant ((1 <= n) && (n <= 1000));
invariant (i != 0);
invariant ((10 mod 2) == 0);
invariant (n >= n);
invariant (10 != 0);
invariant ((s == 0) ==> (j == 0));
invariant (j >= 0);
invariant ((j == 0) ==> (s == 0));
invariant (n != 0);
invariant (i == i);
invariant (10 >= 10);
invariant (i >= 1);
invariant ((i - i) == 0);
invariant ((0 <= 10) && (10 <= 63));
  //invariant 2 * s == i * j && j == i-1 && i <= n + 1;
  {
    s := s + i;
    j := i;
    i := i + 1;
  }
  assert(2*s == n*(n+1));
}
