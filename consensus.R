library(seqinr)
library(argparse)
library(ape)
parser <-  ArgumentParser()
parser$add_argument("trees")
args <- parser$parse_args()
target_dir <- args$trees

treelist <- read.tree(file=target_dir )
consensus_tree <- consensus(treelist, p = 0.5)
write.tree(consensus_tree,file='consensus_tree.nwk')