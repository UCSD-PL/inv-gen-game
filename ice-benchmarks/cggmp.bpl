procedure main() {
    var i,j : int;
    i := 1;
    j := 10;
    
    while (j >= i)
    // invariant 21 == 2*j + i && j >= i - 3;
    {
    	i := i + 2;
    	j := j - 1;
    }
    assert(j == 6);
}
/*
i   j
1   10
3   9
5   8
7   7
9   6
*/
