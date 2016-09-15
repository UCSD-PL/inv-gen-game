// c/loop-invgen/SpamAssassin-loop_true-unreach-call.c

procedure main()
{   
    var len, i, j, bufsize, limit, flag: int;
    
    // bufsize = nondet_int();
    if (bufsize < 0) { 
      return; // avoid overflows for too negative values
    }
    
    //len = nondet_int();
    limit := bufsize - 4;
    
    i := 0;
    while (i < len) {
        j := 0;
        while (i < len && j < limit) {
            if (i + 1 < len){
                assert(i+1<len);
                assert(0<=i);
            }

            if (*) {
              flag := 0;
            } else {
              flag := 1;
            }
            
            if (i + 1 < len && flag == 1) {
                assert(i<len);
                assert(0<=i);
                assert(j<bufsize);
                assert(0<=j);

                j := j + 1;
                i := i + 1;
                assert(i<len);
                assert(0<=i);
                assert(j<bufsize);
                assert(0<=j);

                j := j + 1;
                i := i + 1;
                assert(j<bufsize);
                assert(0<=j);
                j := j + 1;
            } else {
                assert(i<len);
                assert(0<=i);
                assert(j<bufsize);
                assert(0<=j);
                j := j + 1;
                i := i + 1;
            }
        }
    }
}
