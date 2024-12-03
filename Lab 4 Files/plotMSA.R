#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)
outfile <- paste0(args[1],".pdf")
library(msa)


print(paste("now printing a MSA from",args[1],"for user:`",Sys.getenv("MYGIT"),"`... Output is in ", outfile))
print("please wait, faithful Bio312 student; this takes a minute")

aligned_sequences <- readAAStringSet(args[1])
msa_alignment <- new("MsaAAMultipleAlignment", unmasked = aligned_sequences)
msaPrettyPrint(msa_alignment, output = "pdf", askForOverwrite = FALSE, showNames = "left", showLogo = "none",file=outfile,paperWidth=40,paperHeight=16)

print("All done, my friendly Bio312 student!")
