procedure main() {
    var i,j : int;
    i := 1;
    j := 10;
    
    while (j >= i)
    // invariant i - j <= 3 && i - j >= -9 && i + j >= 11 && i + j <= 21 && i >= 1 && j <= 10 && j >= 5 && i <= 12 && (i - (i div 2) * 2 == 1) && i*j >= 10 && (j >= i ==> j >= 6);
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
