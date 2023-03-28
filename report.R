library(seqinr)
library(ape)
library(phangorn)
library(phytools)
library(sys)
library(dplyr)
library(argparse)

parser <-  ArgumentParser()
parser$add_argument("consensus")
parser$add_argument("consensusb")
parser$add_argument("supertree")
parser$add_argument("supertreeb")
parser$add_argument('paralogs')
args <- parser$parse_args()
c1 <- args$consensus
c2 <- args$consensusb
s1 <- args$supertree
s2 <- args$supertreeb
p <- args$paralogs


plot_and_save <- function(tree_loc){
  tree <- read.tree(file=tree_loc)
  pdf(paste(tree_loc,".pdf",sep=''))
  plot(tree)
  dev.off()
}

plot_and_save(c1)
plot_and_save(c2)
plot_and_save(s1)
plot_and_save(s2)
plot_and_save(p)