# Final Repository
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
ncbi-acc-download -h
ncbi-acc-download -F genbank "NW_003143794.1"
ncbi-acc-download -F fasta "NW_003143794.1"
ncbi-acc-download -F gff3 "NW_003143794.1"
```
```
filterGFF LOC100375093 NW_003143794.1.gff
```
```

```
