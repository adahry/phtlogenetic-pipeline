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
treelist <- lapply(temp, function(t){
  file <- paste(paste(target_dir,'/',sep='') , t, sep='')
  sequence <- readAAStringSet(file, skip=1)
  my_alignment <- msa(sequence)
  dat <- as.phyDat(my_alignment)
  dm <- dist.ml(dat)
  tree <- NJ(dm)
  #tree$tip.label <- substr(tree$tip.label, 1, 4)
  final <- as.phylo(tree)
})



tree_list_filtered <- lapply(treelist, function(t){if(length(t$tip.label)==23){return(t)}})
tree_list_filtered <- tree_list_filtered[!sapply(tree_list_filtered,is.null)]


#save to file
write.tree(tree_list_filtered, file='trees.nwk')


