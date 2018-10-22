import sequtils

proc IDE*(T : typedesc[int]) : int = return 0
proc INF*(T : typedesc[int]) : int = return 1 shl 60

proc mongeDP*[T](f : proc(l , r : int) : T , N : int) : T =
  ## calc dp[i][j] = min[i<=k<j](dp[i][k] + dp[k + 1][j]) + f(i,j). takes O(N^2) and Memory O(N^2)
  ## f is required of Quandrangle Inequality and Monotone on the Lattice Intervals.
  ## QI ... f(a or b) + f(a and b) >= f(a) + f(b)
  ## MLI ...if a is partial of b , f(a) <= f(b)
  var
    dp = newSeqWith(N , newSeqWith(N , T.INF))
    k = newSeqWith(N , newSeq[int](N))
  for i in 0..<N:
    dp[i][i] = T.IDE
    k[i][i] = i
  for d in 1..N-1:
    for i in 0..<N-d:
      var 
        j = i + d
        l = k[i][j - 1]
        r = k[i + 1][j]
      for s in l..r:
        if s + 1 >= N: break
        if dp[i][s] + dp[s + 1][j] <= dp[i][j]:
          dp[i][j] = dp[i][s] + dp[s + 1][j]
          k[i][j] = s
      dp[i][j] += f(i , j)
  return dp[0][N - 1]

# verify https://kupc2012.contest.atcoder.jp/submissions/3111654 -> MLE

import strutils

var N = stdin.readline.parseInt
var w = stdin.readline.split.map(parseInt)
w.insert(0,0)
for i in 1..N: w[i] += w[i - 1]
echo mongeDP(proc(l, r : int) : int = return w[r + 1] - w[l] , N)