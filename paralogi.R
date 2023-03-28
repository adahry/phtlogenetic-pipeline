library(seqinr)
library(ape)
library(msa)
library(phangorn)
library(phytools)
library(sys)
library(dplyr)
library(remotes)
library(argparse)

parser <-  ArgumentParser()
parser$add_argument("path")
args <- parser$parse_args()
target_dir <- args$path


temp <- list.files(path=target_dir ,pattern="*.fasta")

#filtering the dataset, do not take files with seq < 3 
file_sel <- lapply(temp, function(t){
  file <- paste(paste(target_dir,'/',sep='') , t, sep='')
  sequence <- readAAStringSet(file)
  if (length(sequence)>3){
    return(file)
  }
  else{return(NA)}
})

file_sel <- file_sel[!is.na(file_sel)]

#making 500 trees from files
treelist <- lapply(sample(file_sel,500), function(t){
  file <- paste(t)
  sequence <- readAAStringSet(file, skip = 1)
  #names(file) <- substr(names(file), 1, 4)
  my_alignment <- msa(sequence)
  dat <- as.phyDat(my_alignment)
  dm <- dist.ml(dat)
  tree <- NJ(dm)
  #tree$tip.label <- substr(tree$tip.label, 1, 4)
  final <- as.phylo(tree)
  
})


write.tree(treelist, file='paralogi.nwk')


