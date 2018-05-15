{
 "anon19_LoopHead": ["(forall l, m: int :: (0 <= l && l < i && l < m && m < 100000) ==> a[l] <= a[m])", "i>=0"],
 "anon20_LoopHead": ["(forall l, m: int :: (0 <= l && l < i && l < m && m < 100000) ==> a[l] <= a[m])",
                     "(forall l : int :: (i <= l && l < k) ==> a[s] <= a[l]) && i <= s && i < k", "s<100000", "i>=0"],
 "anon23_LoopHead": ["(forall l : int :: (i <= l && l < 100000) ==> a[i] <= a[l])", "i>=0", "i<=100000",
                     "(forall l, m: int :: (0 <= l && l < i && l < m && m < 100000) ==> a[l] <= a[m])",
                     "x>=0", "x<=i"],
 "anon24_LoopHead": ["x < y", "(forall l : int :: (i <= l && l < 100000) ==> a[i] <= a[l])", "i>=0", "i<=100000",
                     "(forall l, m: int :: (0 <= l && l < i && l < m && m < 100000) ==> a[l] <= a[m])",
                     "x>=0", "x<=i", "y<=i"],

 "anon25_LoopHead": ["x>= i", "(forall l : int :: (i <= l && l < 100000) ==> a[i] <= a[l])", "i>=0", "i<=100000",
                     "(forall l, m: int :: (0 <= l && l < i && l < m && m < 100000) ==> a[l] <= a[m])"],
 "anon26_LoopHead": ["(forall l, m: int :: (0 <= l && l < m && m < 100000) ==> a[l] <= a[m])", "x>=0"],
 "anon27_LoopHead": ["(forall l, m: int :: (0 <= l && l < m && m < 100000) ==> a[l] <= a[m])", "y>x",
                     "x>=0"]
}
