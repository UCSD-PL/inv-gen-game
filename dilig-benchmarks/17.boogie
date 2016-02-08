procedure run(n: int)
{
  var i, j, k: int;
 	k := 1;
 	i := 1;
 	j := 0;
 
 	while(i < n)
  invariant (k >= i);
  {	
  	j := 0;

  	while(j < i)
    invariant (j <= i) && (k > j);
    {
    	k := k + (i - j);
    	j := j + 1;
  	}
  	i := i + 1;
 	}
 	assert(k>=n);
}