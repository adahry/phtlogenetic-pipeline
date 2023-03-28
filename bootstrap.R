library(seqinr)
library(ape)
library(msa)
library(phangorn)
library(phytools)
library(sys)

library(argparse)

parser <-  ArgumentParser()
parser$add_argument("path")
args <- parser$parse_args()
target_dir <- args$path

temp = list.files(path=target_dir ,pattern="*.fasta")
##BOOTSRAP
set.seed(123)
treelist_bootstrap <- lapply(temp, function(t){
  file <- paste(paste(target_dir,'/',sep='') , t, sep='')
  sequence <- readAAStringSet(file, skip=1)
  my_alignment <- msa(sequence)
  dat <- as.phyDat(my_alignment)
  dm <- dist.ml(dat)
  tree <- NJ(dm)
  if(length(tree$tip.label)==23){
    fit <- pml(tree, data=dat)
    bs <- bootstrap.pml(fit, bs=100, optNni=TRUE, multicore=TRUE)
    final <- plotBS(fit$tree, bs,'p')
  }
  else{final <- NULL}
})

tree_list_filtered_b <- treelist_bootstrap[!sapply(treelist_bootstrap,is.null)]

the_best_trees <- lapply(tree_list_filtered_b, function(t){
  if((t$node.label %>% as.integer() %>%  mean(na.rm=TRUE))>60){
    t
  }
  else{NULL}
})
the_best_trees  <- the_best_trees[!sapply(the_best_trees ,is.null)]
write.tree(the_best_trees, file='afterbootstrap.nwk')

