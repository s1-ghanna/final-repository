# Final Repository
## Lab 2 Analysis
After setting up and connecting to the BIO312 instance through Visual Studio code, I began my analysis with the following commands.
```
git clone https://github.com/Bio312/lab02-myusername
cd lab02-myusername
MYGIT="s1-ghanna"
echo "export MYGIT=$MYGIT" >> ~/.bashrc
```
After navigating to my Lab 2 repository, the command "MYGIT="s1-ghanna" set "s1-ghanna" as the variable whenever I typed in $MYGIT, and the command "echo "export MYGIT=$MYGIT" >> ~/.bashrc" saved this variable for future use.
```
cd ~/lab02-$MYGIT
ncbi-acc-download -F genbank "NW_003143794.1"
ncbi-acc-download -F fasta "NW_003143794.1"
ncbi-acc-download -F gff3 "NW_003143794.1"
```
The second of the above 4 commands was used to download the scaffold NW_003143794.1 in genbank format, the third in FASTA format, and the fourth in general feature format.
```
filterGFF LOC100375093 NW_003143794.1.gff
```
This command makes 3 new GFF files: a file with the coordinates of all features for the gene of interest, a file filtered to include only transcript variant X1, and a file filtered to include only the CDS (Coding Sequence) features.
```
gt gff3 -sort -tidy -force -o LOC100375093.sorted.gff LOC100375093.X1.gff
gt stat -genelengthdistri -exonlengthdistri -intronlengthdistri -cdslengthdistri -addintrons -force -o LOC100375093.sorted.counts.gff LOC100375093.sorted.gff
less LOC100375093.sorted.counts.gff
```
The first of the above 3 commands was used to sort the LOC100375093.X1.gff file, the second command calculated the gene lengths, exon lengths, intron lengths, and CDS lengths, and the third command was used to see the results of the second command.
```
gt gff3 -sort -tidy -o NW_003143794.1.sorted.gff NW_003143794.1.gff
gt stat -genelengthdistri -exonlengthdistri -intronlengthdistri -cdslengthdistri -addintrons -force -o NW_003143794.1.counts.txt NW_003143794.1.sorted.gff
less NW_003143794.1.counts.txt
```
This command trio was very similar to the previous trio except that the second command sought out length distributions for genes, exons, introns, and CDS.
```
grep CDS LOC100375093.X1.gff > LOC100375093.X1.cds.gff
bedtools getfasta -s -fi NW_003143794.1.fa -fo LOC100375093.X1.cds.fa -bed LOC100375093.X1.cds.gff
less LOC100375093.X1.cds.fa
```
The first command searched the LOC100375093.X1.gff file for lines containing CDS and put that output into the LOC100375093.X1.cds.gff file. The second command put LOC100375093.X1.cds.gff into FASTA format. The third command displayed the results of the second command.
```
union LOC100375093.X1.cds.fa -outseq LOC100375093.X1.cds.union.fa
transeq LOC100375093.X1.cds.union.fa LOC100375093.X1.protein.fa
less LOC100375093.X1.protein.fa
```
The first of the above 3 commands was used to join the exons in the CDS together, the second command translated that result into a protein sequence, and the third command showed the results of the second command.
## Lab 3 Analysis
```
git clone https://github.com/Bio312/lab03-$MYGIT
cd lab03-$MYGIT
```
Used to navigate to my Lab 3 repository.
```
mkdir ~/lab03-$MYGIT/ECI
cd ~/lab03-$MYGIT/ECI
```
Used to create and navigate to the directory ECI (short for <ins>e</ins>noyl-<ins>C</ins>oA <ins>i</ins>somerase, the gene I studied) for this lab.
```
ncbi-acc-download -F fasta -m protein "NP_996667.2"
blastp -db ../allprotein.fas -query NP_996667.2.fa -outfmt 0 -max_hsps 1 -out ECI.blastp.typical.out
less ECI.blastp.typical.out
```
The first command downloaded the enoyl-CoA isomerase protein from Homo sapiens as the query sequence. The second above command did a BLAST search on this query sequences, and the third command displayed the results.
```
blastp -db ../allprotein.fas -query NP_996667.2.fa  -outfmt "6 sseqid pident length mismatch gapopen evalue bitscore pident stitle"  -max_hsps 1 -out ECI.blastp.detail.out
less -S ECI.blastp.detail.out
```
These two commands were very similar to the second and third commands from the previous trio, except this next "blastp" command created a more detailed and easily processed version of ECI.blastp.typical.out.
```
awk '{if ($6< 1e-30)print $1 }' ECI.blastp.detail.out > ECI.blastp.detail.filtered.out
wc -l ECI.blastp.detail.filtered.out
grep -o -E "^[A-Z]\.[a-z]+" ECI.blastp.detail.filtered.out  | sort | uniq -c
```
The first command filtered the BLAST search from the previous two commands by an E-value of 1e-30. The second command showed the total number of BLAST hits (matches) post-filtering, and the third command told me about the number of enoyl-CoA isomerase paralogs in each of the following species: _C. carcharias, C. mydas, D. rerio, E. caballus, F. catus, G. aculeatus, G. gallus, H. sapiens, S. salar, S. townsendi,_ and _X. laevis_.
## Lab 4 Analysis
```
mkdir ~/lab04-$MYGIT/ECI
cd ~/lab04-$MYGIT/ECI
```
Used to create and navigate to the directory ECI for this lab.
```
seqkit grep --pattern-file ~/lab03-$MYGIT/ECI/ECI.blastp.detail.filtered.out ~/lab03-$MYGIT/allprotein.fas | seqkit grep -v -p "carpio" > ~/lab04-$MYGIT/ECI/ECI.homologs.fas
muscle -align ~/lab04-$MYGIT/ECI/ECI.homologs.fas -output ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas
alv -kli  ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | less -RS
alv -kli --majority ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | less -RS
```
The first command retrieved desired sequences from ECI.blastp.detail.filtered.out for alignment. The "muscle" command did a multiple sequence alignment of said sequences. Both "alv -kli" commands were used to view the results of the Muscle alignment in slightly different formats (the fourth command displayed only the color of those columns where the most common amino acid was found in 50 percent of sequences).
```
Rscript --vanilla ~/lab04-$MYGIT/plotMSA.R  ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas
alv -kil -w 100 ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | aha > ~/lab04-$MYGIT/ECI/ECI.homologs.al.html
a2ps -r --columns=1 ~/lab04-$MYGIT/ECI/ECI.homologs.al.html -o ~/lab04-$MYGIT/ECI/ECI.homologs.al.ps
ps2pdf ~/lab04-$MYGIT/ECI/ECI.homologs.al.ps ~/lab04-$MYGIT/ECI/ECI.homologs.al.pdf
```
The above commands were supposed to create a PDF of my alignment, but they were broken.
```
alignbuddy  -al  ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas
alignbuddy -trm all  ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | alignbuddy  -al
alignbuddy -dinv 'ambig' ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | alignbuddy  -al
```
The first command gave the alignment length, the second command gave the alignment length after removing columns with gaps, and the third column gave the alignment length after removing completely conserved positions.
```
t_coffee -other_pg seq_reformat -in ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas -output sim
alignbuddy -pi ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | awk ' (NR>2)  { for (i=2;i<=NF  ;i++){ sum+=$i;num++} }
     END{ print(100*sum/num) } '
```
Both of the above commands calculated average percent identity of the sequence alignment (t_coffee excluded gapped positions while alignbuddy included them).
## Lab 5 Analysis
```
mkdir ~/lab05-$MYGIT/ECI
cd ~/lab05-$MYGIT/ECI
```
Used to create and navigate to the directory ECI for this lab.
```
sed 's/ /_/g'  ~/lab04-$MYGIT/ECI/ECI.homologs.al.fas | seqkit grep -v -r -p "dupelabel" >  ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas
iqtree -s ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas -bb 1000 -nt 2
```
The first command removed sequences with duplicate labelled tags from ECI.homologs.al.fas and put that copy from Lab 4's ECI directory to Lab 5's ECI directory. The second command calculated the maximum likelihood tree estimate.
```
nw_display ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas.treefile
Rscript --vanilla ~/lab05-$MYGIT/plotUnrooted.R  ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas.treefile ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas.treefile.pdf 0.4 15
```
The "nw_display" command displayed an ASCII graphics version of the maximum likelihood tree. The R script showed this tree in an easier-to-read graphical display.
```
gotree reroot midpoint -i ~/lab05-$MYGIT/ECI/ECI.homologsf.al.fas.treefile -o ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile
nw_order -c n ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile  | nw_display -
nw_order -c n ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile | nw_display -w 1000 -b 'opacity:0' -s  >  ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile.svg -
convert  ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile.svg  ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile.pdf
```
The first of the above 4 commands rerooted the tree to be midpoint-rooted. The second command displayed an ASCII graphics version of this newly rooted tree, the third command created a graphical display in a .svg file, and the fourth command turned the .svg file into a PDF.
```
nw_order -c n ~/lab05-$MYGIT/ECI/ECI.homologsf.al.mid.treefile | nw_topology - | nw_display -s  -w 1000 > ~/lab05-$MYGIT/ECI/ECI.homologsf.al.midCl.treefile.svg -
convert ~/lab05-$MYGIT/ECI/ECI.homologsf.al.midCl.treefile.svg ~/lab05-$MYGIT/ECI/ECI.homologsf.al.midCl.treefile.pdf
```
These two commands served the same purpose as the two commands right before them, except all branches were made to have equal lengths.
## Lab 6 Analysis
## Lab 7 Analysis
## Lab 8 Analysis
