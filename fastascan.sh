#!/user/bin/bash

#$sh fastascan.sh folder N
#1. the folder X where to search files (default: current folder); 
if [[ $1 -n ]];
then
fastafiles=$(find $1 -type f -name "*.fa" -or -name ".fasta");
else
fastafiles=$(find . -type f -name "*.fa" -or -name ".fasta");
fi

#2. a number of lines, here called N (default: 0)
if [[ $2 -n ]];
then
N=$2;
else
N="0"
fi
#The report should include this information:
#how many such files there are
for i in $fastafiles;
do
	if [[ $n_lines -gt 1 ]];
	then 
	echo There are $n_files;
	ifelse [[ $n_lines -eq 1]];
	then
	echo There are no fasta files;
	else
	echo There is 1 fasta files; 
	fi;
#how many unique fasta IDs (i.e. the first words of fasta headers) they contain in total 
	grep ">" $i | uniq
	 
#for each file:
#	print a nice header including filename; and:
#	whether the file is a symlink or not
#	how many sequences there are inside
#	the total sequence length in each file, i.e. the total number of amino acids or nucleotides of all sequences in the file. NOTE: gaps "-", spaces, newline characters should not be counted
#Extra points: determine if the file is nucleotide or amino acids based on their content, and print a label to indicate this in this header
#next, if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.
