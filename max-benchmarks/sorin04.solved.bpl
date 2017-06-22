// interesting way to compute cubes, but requires Gauss invariant, which
// we can't do yet. So I think we clearly won't be able to do this one, but
// useful to keep in mind
procedure main() {
  var i,a,c: int;
  i := 0;
  a := 0;
  c := 0;
  while (i < 10)
invariant (a == a);
invariant (i == i);
invariant (c == c);
//invariant ((0 <= a) && (a <= 63));
//invariant (a <= 55);
//invariant (a >= 0);
invariant (a >= 0);
//invariant (((((((((((((((((((((((((a == 0) || (a == 1)) || (a == 3)) || (a == 2)) || (a == 8)) || (a == 6)) || (a == 27)) || (a == 10)) || (a == 4)) || (a == 64)) || (a == 15)) || (a == 5)) || (a == 125)) || (a == 21)) || (a == 216)) || (a == 28)) || (a == 7)) || (a == 343)) || (a == 36)) || (a == 512)) || (a == 45)) || (a == 9)) || (a == 729)) || (a == 55)) || (a == 1000));
invariant ((0 <= i) && (i <= 63));
invariant (i <= 10);
//invariant (i >= 0);
invariant (i >= 0);
invariant (((((((((((((((((((((((((i == 0) || (i == 1)) || (i == 3)) || (i == 2)) || (i == 8)) || (i == 6)) || (i == 27)) || (i == 10)) || (i == 4)) || (i == 64)) || (i == 15)) || (i == 5)) || (i == 125)) || (i == 21)) || (i == 216)) || (i == 28)) || (i == 7)) || (i == 343)) || (i == 36)) || (i == 512)) || (i == 45)) || (i == 9)) || (i == 729)) || (i == 55)) || (i == 1000));
//invariant (c <= 1000);
//invariant (c >= 0);
invariant (c >= 0);
//invariant (((((((((((((((((((((((((c == 0) || (c == 1)) || (c == 3)) || (c == 2)) || (c == 8)) || (c == 6)) || (c == 27)) || (c == 10)) || (c == 4)) || (c == 64)) || (c == 15)) || (c == 5)) || (c == 125)) || (c == 21)) || (c == 216)) || (c == 28)) || (c == 7)) || (c == 343)) || (c == 36)) || (c == 512)) || (c == 45)) || (c == 9)) || (c == 729)) || (c == 55)) || (c == 1000));
invariant ((a - a) == 0);
invariant ((a == 0) ==> (i == 0));
invariant ((i == 0) ==> (a == 0));
invariant (a >= i);
invariant ((a == 0) ==> (c == 0));
invariant ((c == 0) ==> (a == 0));
invariant (a <= c);
invariant ((i - i) == 0);
invariant ((c == 0) ==> (i == 0));
invariant ((i == 0) ==> (c == 0));
invariant (i <= c);
//invariant ((c - c) == 0),21,((i == 0) ==> (a == 0));
invariant (a <= c);
invariant ((a == 0) ==> (c == 0));
invariant (a >= 0);
invariant ((c == 0) ==> (a == 0));
invariant (i <= 10);
invariant (i >= 0);
invariant (i <= c);
invariant ((a == 0) ==> (i == 0));
invariant (i == i);
invariant ((a - a) == 0);
invariant (c == c);
invariant ((0 <= i) && (i <= 63));
invariant ((c - c) == 0);
invariant ((c == 0) ==> (i == 0));
invariant (c >= 0);
invariant (a == a);
invariant (a >= i);
invariant ((i - i) == 0);
invariant (((((((((((((((((((((((((i == 0) || (i == 1)) || (i == 3)) || (i == 2)) || (i == 8)) || (i == 6)) || (i == 27)) || (i == 10)) || (i == 4)) || (i == 64)) || (i == 15)) || (i == 5)) || (i == 125)) || (i == 21)) || (i == 216)) || (i == 28)) || (i == 7)) || (i == 343)) || (i == 36)) || (i == 512)) || (i == 45)) || (i == 9)) || (i == 729)) || (i == 55)) || (i == 1000));
invariant ((i == 0) ==> (c == 0));
  //invariant i * (i+1) == 2*a && c == i*i*i;
  {
    c := c + (6*a) + 1;
    a := a + i + 1;
    i := i + 1;
  }
  assert(c ==  i*i*i);
}
