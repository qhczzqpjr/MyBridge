--by comparing the before and after we will know which phases entered
SELECT * FROM sys.dm_exec_query_optimizer_info
/*
One the initial Memo has been populated from the input tree, the optimizer runs up to four phases of search
Trival plan
Search 0 – Transaction Processing
Search 1 – Quick Plan (also known as Complex Query I)
Search 2 – Full Optimization

the four phrase will explore new logical alternatives to some part of the tree and apply rules to convert it to physical implementations.
Costing considers factors like cardinality, average row size, expected sequential and random I/O operations, processor time, buffer pool memory requirements, and the effect of parallel execution.
Get the good enough plan within the time limit.
http://www.csd.uoc.gr/~hy460/pdf/CascadesFrameworkForQueryOptimization.pdf
trace flag 8615
*/