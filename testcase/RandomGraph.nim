import sequtils , algorithm , strutils , random

var seed = stdin.readline.parseInt

var r = initRand(seed)

var N = stdin.readline.parseInt

var M = 2 * N

for i in 1..M:
  echo r.rand(N - 1) , " " , r.rand(N - 1)
