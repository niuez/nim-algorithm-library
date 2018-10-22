# MongeDP

## IDE


```nim
proc IDE*(T: typedesc[int]): int
```
## INF


```nim
proc INF*(T: typedesc[int]): int
```
## mongeDP

calc dp[i][j] = min[i&lt;=k&lt;j](dp[i][k] + dp[k + 1][j]) + f(i,j). takes O(N^2) and Memory O(N^2) f is required of Quandrangle Inequality and Monotone on the Lattice Intervals. QI ... f(a or b) + f(a and b) &gt;= f(a) + f(b) MLI ...if a is partial of b , f(a) &lt;= f(b)
```nim
proc mongeDP*[T](f: proc (l, r: int): T; N: int): T
```
