function {:existential true} b0(x:int, n:int): bool;
procedure main() {
	var x, n : int;
	assume n > 0;
	x := 0;

 	while ( 0 == 0 )
invariant b0(x, n);
  // invariant x <= n;
  {
		if ( * ) {
			x := x + 1;
			if (x >= n ) {
				break;
			}
		}
	}
	assert(x == n);
}
