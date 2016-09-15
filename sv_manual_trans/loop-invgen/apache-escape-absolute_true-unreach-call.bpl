procedure main()
{
    var scheme, urilen, tokenlen, cp, c, LARGE_INT: int;
    //urilen = nondet_int();
    //tokenlen = nondet_int();
    //scheme = nondet_int();
    assume(LARGE_INT > 1000);
    assume(urilen <= LARGE_INT && urilen >= -LARGE_INT);
    assume(tokenlen <= LARGE_INT && tokenlen >= -LARGE_INT);
    assume(scheme <= LARGE_INT && scheme >= -LARGE_INT);

    assume(urilen>0);
    assume(tokenlen>0);
    assume(scheme >= 0 );
    assume(!(scheme == 0 || (urilen-1 < scheme)));

    cp := scheme;

    assert(cp-1 < urilen);
    assert(0 <= cp-1);

    if (*) {
        assert(cp < urilen);
        assert(0 <= cp);
        while ( cp != urilen-1)
        invariant cp <= urilen - 1;
        {
            if(*) {
              break;
            }
            assert(cp < urilen);
            assert(0 <= cp);
            cp := cp + 1;
        }
        assert(cp < urilen);
        assert( 0 <= cp );
        if (cp != urilen-1) {
          assert(cp+1 < urilen);
          assert( 0 <= cp+1 );
          if (cp+1 != urilen-1) {
            cp := cp + 1;

            scheme := cp;

            if (*) {
              c := 0;
              assert(cp < urilen);
              assert(0<=cp);
              while ( cp != urilen-1
                    && c < tokenlen - 1)
              invariant cp <= urilen - 1;
              {
                assert(cp < urilen);
                assert(0<=cp);
                if (*) {
                    c := c + 1;
                    assert(c < tokenlen);
                    assert(0<=c);
                    assert(cp < urilen);
                    assert(0<=cp);
                }
                cp := cp + 1;
              }
            }
          }
        }
    }
}
