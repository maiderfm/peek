#!/user/bin/bash

#$sh fastascan.sh folder N
if [[ -d $1 ]]; #1. the folder X where to search files (default: current folder); 
then
n_files=$(find $1 -type f -name "*.fa" -or -name ".fasta" | wc -l );
else
n_files=$(find . -type f -name "*.fa" -or -name ".fasta" | wc -l);
fi;

#2. a number of lines, here called N (default: 0)
if [[ -n $2  ]];
then
N=$2;
else
N="0"
fi

echo Searching for fasta files in $1
echo Number of lines specified $N

echo $n_lines
#The report should include this information:
	if [[ $n_files -gt 1 ]];#how many such files there are	
	then 
		echo There are $n_files;
	ifelse [[ $n_files -eq 1]];
		echo There is 1 fasta files; 
	else
		echo There are no fasta files;
	fi;
	
for i in $fastafiles;
do

#how many unique fasta IDs (i.e. the first words of fasta headers) they contain in total 
	grep ">" $i | uniq
	 
#for each file:
filename=$(echo $i)
symlnk=$(if [[ $i -h ]]; then echo "YES"; else echo "NO")
numberseq=$(grep -c ">" $i )
seqlength=$(for f in $(grep -v ">" $i); do wc -c; done)
echo File name: $filename Symlink: $symlnk Number of sequences: $numberseq Sequence length: $seqlength
#	print a nice header including filename; and:
#	whether the file is a symlink or not
#	how many sequences there are inside
#	the total sequence length in each file, i.e. the total number of amino acids or nucleotides of all sequences in the file. NOTE: gaps "-", spaces, newline characters should not be counted
#Extra points: determine if the file is nucleotide or amino acids based on their content, and print a label to indicate this in this header
#next, if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.
