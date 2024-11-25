#!/usr/bin/bash

#$sh fastascan.sh folder N

#Specify the folder to be searched and the number of lines
if [[ -d $1 ]];   #If the first argument is a folder
then
	name_folder=$1
	fastafiles=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \));
	n_files=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \) | wc -l );
	echo Searching for fasta files in $1
		
		if [[ -n $2 ]];
		then
			N=$2; else N=0;
		fi
		echo Number of lines specified = $N

else 	#if not, search the current folder as default 
	name_folder="current directory"
	fastafiles=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \));
	n_files=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \)| wc -l );

	echo Searching for fasta files in current directory
	
		if [[ -n $1 ]];
		then
			N=$1; else  N=0;
		fi
		echo Number of lines specified = $N
fi

#Print the number of files in the folder being searched
	if [[ $n_files -gt 1 ]];	
	then 
		echo There are $n_files fasta files;
	elif [[ $n_files -eq 1 ]];
	then 
		echo There is 1 fasta files; 
	else
		echo There are no fasta files;
	fi;


for i in $(echo $fastafiles);
do
	#Print all fasta sequence identifiers (first element of the fasta header)
		echo All fasta identifiers in $name_folder :
		echo $(grep ">" $i 2>err| sed '/>/ s/>//' | awk '{print $1}' | sort | uniq)
	
	#For each file print a header that contains:
		filename=$(echo $i| awk '{split($0, str, "/"); print str[length(str)]}') #Name of file
		symlnk=$(if [[ -h $i ]]; then echo "YES"; else echo "NO"; fi) #Wether it is a symlink
		numberseq=$(grep -c ">" $i 2>err ) #Number of sequences
		seqlength=$(sed '/>/! s/\n-//g' $i | wc -c)  #Total length of the sequences. Gaps "-", spaces, newline characters not counted
		#Wether the sequence contains nucleotides or aminoacids
		seq_nuc=$(grep -v ">" "$i" 2>err | grep '[atgcunATGCUN]')
		seq_prot=$(grep -v ">" "$i" 2>err| grep '[^atgcnuATGCNU]') 
			if [[ -n $seq_nuc && -n $seq_prot ]]; then 
				seq_type=Aminoacid
			elif [[ -n $seq_nuc ]]; then 
				seq_type=Nucleotide
			else 
				seq_type=Unknown
			fi

	#Print header
	echo " "
	echo  /// File name: $filename /// Symlink: $symlnk /// Number of sequences: $numberseq /// Sequence length: $seqlength /// Type of sequence: $seq_type
	echo " "
	

	#Print contents depending on the number of lines its file has and the number specified.
	n_lines=$(cat $i | wc -l)
	if [[ n_lines -le $(( 2*$N )) ]];	#if the file has 2N lines or fewer, display full content.
	then 
	cat $i;
	elif [[ n_lines -eq 0 ]] 			#if no N is specified, skip step.
	then
		continue
	else 								#else print first N lines, then "...", then last N lines.
	head -n $N $i
	echo "..."
	tail -n $N $i
	fi;

done
