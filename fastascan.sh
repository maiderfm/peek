#!/user/bin/bash

#$sh fastascan.sh folder N
if [[ -d $1 ]]; #1. the folder X where to search files (default: current folder); 
then
fastafiles=$(find $1 -type f -or -type l -name "*.fa" -or -name "*.fasta");
n_files=$(find $1 -type f -or -type l -name "*.fa" -or -name "*.fasta" | wc -l );
else
fastafiles=$(find . -type f -or -type l -name "*.fa" -or -name "*.fasta");
n_files=$(find . -type f -or -type l -name "*.fa" -or -name "*.fasta" | wc -l );
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

#The report should include this information:
	if [[ $n_files -gt 1 ]];#how many such files there are	
	then 
		echo There are $n_files fasta files;
	elif [[ $n_files -eq 1 ]];
	then 
		echo There is 1 fasta files; 
	else
		echo There are no fasta files;
	fi;
	
#for each file:
for i in $(echo $fastafiles);
do
	filename=$(echo $i)
	symlnk=$(if [[ -h $i ]]; then echo "YES"; else echo "NO"; fi)
	numberseq=$(grep -c ">" $i )
	seqlength=$(grep -v ">" $i | grep -vw "-" | wc -c)  #gaps "-", spaces, newline characters should not be counted

#	print a nice header including filename; and:
echo File name: $filename Symlink: $symlnk 
echo Number of sequences: $numberseq Sequence length: $seqlength
	#	whether the file is a symlink or not
	#	how many sequences there are inside
	#	the total sequence length in each file, i.e. the total number of amino acids or nucleotides of all sequences in the file. NOTE: gaps "-", spaces, newline characters should not be counted
	#Extra points: determine if the file is nucleotide or amino acids based on their content, and print a label to indicate this in this header

#next, if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.
n_lines=$(cat $i | wc -l)
if [[ n_lines -le $(( 2*$N )) ]];
then 
cat $i;
elif [[ n_lines -eq 0 ]]
then
	continue
else
head -n $N $i
echo "..."
tail -n $N $i
fi;

done
#next, if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.

