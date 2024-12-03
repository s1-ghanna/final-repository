#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# wget https://raw.githubusercontent.com/Bio312/lab4files/main/plotTreeAndDomains.r
#sudo /usr/local/bin/Rscript  --vanilla ~/labs/lab8-$MYGIT/plotTreeAndDomains.r ~/labs/lab5-$MYGIT/gqr/gqr.homologs.al.mid.treefile ~/labs/lab8-$MYGIT/gqr/gqr.rps-blast.out  ~/labs/lab8-$MYGIT/gqr/gqr.homologs.fas ~/labs/lab8-$MYGIT/gqr/gqr.tree.rps.pdf
#Rscript  --vanilla plotTreeAndDomains.r mutS.homologs.al.mid.tre mutS.rps-blast.txt  mutS.homologs.fas mutS.tree.rps.pdf


# test if there is at least one argument: if not, return an error
if (length(args)<4) {
  stop("You must provide (1) a tree file (2) domain file (3) fasta sequences (4) output file name for pdf.", call.=FALSE)
} 

#if (!require("BiocManager", quietly = TRUE))
#install.packages("BiocManager")
#BiocManager::install("drawProteins")
#install.packages("ggrepel", repos = "http://cran.us.r-project.org")

library(ggtree)
library(data.table)
library(drawProteins)
library(ggplot2)
#library(ggrepel)
library(seqinr)

hoxt <- read.tree(args[1]) #"hox.bs.mid.suptree"

#t <- ggtree(hoxt, aes(x, y)) + geom_tree() + theme_tree()  + geom_tiplab(cex=0.9) + geom_text2(size=2,aes(subset = !isTip, label=label))   + ggplot2::xlim(0, 6) 
t <- ggtree(hoxt, aes(x, y), branch.length='none') + geom_tree() + theme_tree()  + geom_tiplab(cex=2.5) + geom_label2(size=2.5,aes(subset = !isTip, label=label),nudge_x=0,nudge_y=.175,  label.padding = unit(0.05, "lines")) + ggplot2::xlim(0, max(24,0.389*(sum(hoxt$edge.length))-26.389 )) +      theme(plot.margin=unit(c(0,0,0,0), "mm"))
t2 <- ggtree(hoxt, aes(x, y)) + geom_tree() + theme_tree()  + geom_tiplab(cex=2.5) + geom_label2(size=2.5,aes(subset = !isTip, label=label),nudge_x=0,nudge_y=.175,  label.padding = unit(0.05, "lines")) + ggplot2::xlim(0, max(24,0.389*(sum(hoxt$edge.length))-26.389 )) +      theme(plot.margin=unit(c(0,0,0,0), "mm"))

#t <- ggtree(hoxt, aes(x, y)) + geom_tree() + theme_tree()  + geom_tiplab(cex=0.9) +  geom_label_repel(aes(label=label, fill=label))  + ggplot2::xlim(0, max(6,0.389*(sum(hoxt$edge.length))-26.389 ))


torder <- data.frame("entryName" = get_taxa_name(t), "order" = length(get_taxa_name(t)):1)

hoxd <- fread(args[2]) #"hox.rps-blast.out"

rel_data0 <- hoxd[,c(1:4,6)]
colnames(rel_data0) <- c("V1","V2","V3","V4","V5")
rel_data0$type <- "DOMAIN"

#reldatachain0 <- rel_data0[!(duplicated(rel_data0$V1)),]
#reldatachain <- data.frame("V1"="","V2"=reldatachain0$V2,"V3"=1,"V4"=reldatachain0$V2,"V5"=reldatachain0$V1,"type"="CHAIN")
#reldatachain <- data.frame("V1"=reldatachain0$V1,"V2"=reldatachain0$V2,"V3"=1,"V4"=reldatachain0$V2,"V5"=reldatachain0$V1,"type"="CHAIN")
reldatachain0 <- read.fasta(args[3]) #~/labs/lab8-$MYGIT/gqr/gqr.homologs.fas 
reldatachain <- data.frame("V1"=names(reldatachain0),"V2"=getLength(reldatachain0),"V3"=1,"V4"=getLength(reldatachain0),"V5"=names(reldatachain0),"type"="CHAIN")

rel_data1 <- rbind(rel_data0,reldatachain)
rel_data2 <- as.data.frame(rel_data1[,c(6,5,3,4,2,1,1)])
rel_data2$taxid <- 1
colnames(rel_data2) <-  c( "type", "description", "begin","end","length","accession","entryName","taxid")
rel_data2$description <- sapply(rel_data2$description, function(dx) substr(dx, 1, 100))
rel_data3 <- merge(rel_data2,torder,all.x=TRUE,all.y=TRUE)

draw_canvas(rel_data3) -> p0

p1 <- draw_chains(p0, rel_data3,label_chains = FALSE,  outline = "black")

p2 <- draw_domains(p1,rel_data3,label_domains=FALSE,show.legend=TRUE)

p <- draw_domains(p1, rel_data3,label_domains = FALSE,label_size=0.7,show.legend=FALSE) + theme_bw(base_size = 20) + # white background
    theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank()) +
    theme(axis.ticks = element_blank(), 
        axis.text.y = element_blank()) +
    theme(panel.border = element_blank())+
 theme(legend.text=element_text(size=8))+
  theme(legend.key.size = unit(0.2, 'cm'))+
    theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
        theme(legend.title= element_blank())+
#     theme(plot.margin=unit(c(-5,5,-5,-5), "mm"))+
     theme(plot.margin=unit(c(-8,0,-10,-5), "mm"))+
# theme(legend.position = c(1,1)) + 
#theme(legend.position="right", legend.box = "vertical")+
 theme(legend.position = c(-0.25, 0.25),
#labs(fill="") +
#   theme(panel.background=element_rect(fill="transparent",colour=NA),
 #     plot.background=element_rect(fill="transparent",colour=NA),
 #     legend.key = element_rect(fill = "transparent", colour = "transparent"), 
legend.background = element_rect(fill="transparent"))

pdf(args[4],paper="USr",width=10.5,height=7)
multiplot(t, p,ncol=2,widths=c(8,2))
multiplot(t2, p,ncol=2,widths=c(8,2))
p2
dev.off()

print(paste0(args[3],", a pdf file, has been outputted"))




