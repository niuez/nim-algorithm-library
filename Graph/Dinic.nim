import sequtils,queues
type
  DinicEdge* = object
    ## Edge Object , edit this to add more information like distance.
    to : int
    cap : int
    rev : int
  Graph*[E] = seq[seq[E]]
  Dinic* = Graph[DinicEdge]
    ## Graph Object.

proc newGraph*[E](n : int) : Graph[E] =
  ## create n size new Graph.
  var g : Graph[E] = newSeqWith(n , newSeq[E](0))
  return g

proc size*[E](g : Graph[E]) : int =
  ## size of Graph
  return g.len

proc addEdge(g : var Dinic , fr , to , cap , rev_cap : int) =
    g[fr].add(DinicEdge(to : to , cap : cap , rev : g[to].len))
    g[to].add(DinicEdge(to : fr , cap : rev_cap , rev : g[fr].len - 1))

proc dinic_level(g : Dinic , s , t : int) : seq[int] =
    var
        level = newSeqWith(g.size , -1)
        que = initQueue[int]()
    level[s] = 0
    que.add(s)
    while que.len > 0:
        var v = que.front
        que.pop
        for e in g[v]:
            if e.cap > 0 and level[e.to] == -1:
                level[e.to] = level[v] + 1
                que.add(e.to)
    return level

proc dinic_dfs(g : var Dinic , v , t , f : int , itr : var seq[int] , level : var seq[int]) : int =
    if v == t: return f
    while itr[v] < g[v].len:
        if g[v][itr[v]].cap > 0 and level[g[v][itr[v]].to] > level[v]:
            var mi_f = g.dinic_dfs(g[v][itr[v]].to , t , min(f , g[v][itr[v]].cap) , itr , level)
            if mi_f > 0:
                g[v][itr[v]].cap -= mi_f
                g[g[v][itr[v]].to][g[v][itr[v]].rev].cap += mi_f
                return mi_f
    return 0

proc max_flow(g : var Dinic , s , t : int) : int =
    var result = 0
    var flow = 0
    while true:
        var level = g.dinic_level(s , t)
        if level[t] >= 0: break
        var itr = newSeqWith(g.size , 0)
        while true:
            flow = g.dinic_dfs(s,t,(int)1e9 , itr , level)
            if flow <= 0: break
            result += flow
    return result
