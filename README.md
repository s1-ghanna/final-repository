# Final Repository
## Lab 2 Analysis
After setting up and connecting to the BIO312 instance through Visual Studio code, I began my analysis with the following commands.
```
git clone https://github.com/Bio312/lab02-myusername
cd lab02-myusername
MYGIT="s1-ghanna"
echo "export MYGIT=$MYGIT" >> ~/.bashrc
```
The command "MYGIT="s1-ghanna" set "s1-ghanna" as the variable whenever I typed in $MYGIT, and the command "echo "export MYGIT=$MYGIT" >> ~/.bashrc" saved this variable for future use.
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
## Lab 4 Analysis
## Lab 5 Analysis
## Lab 6 Analysis
## Lab 7 Analysis
## Lab 8 Analysis
