#!/usr/bin/bash

#$sh fastascan.sh folder N

#######################################################################################################################
# Specify the folder to be searched and the number of lines
#######################################################################################################################

#If the first argument is a folder that exists
	if [[ -d $1 ]]; 
	then
	
		if [[ -x $1 && -r $1  ]]; #If the folder has permissions
		then
		name_folder=$1
		fastafiles=$(find $1 \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \) ! -name ".*");
		n_files=$(find $1 \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \) ! -name ".*" | wc -l );
		echo Searching for fasta files in $1
			
		else echo "$1: Permission denied" ; exit  #If folder doesn't have permissions
		fi
		
	#If is not a folder that exists or no folder is specified, search the current folder as default
	elif [[ -z $1 || -n $1 && ! -d $1 ]] 
	then	
		name_folder="current directory"
		fastafiles=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \) ! -name ".*");
		n_files=$(find . \( -type f -or -type l \) \( -name "*.fa" -or -name "*.fasta" \) ! -name ".*"| wc -l );
		echo Searching for fasta files in the current directory
	fi
			
#Number of lines specified		
	if [[ -n $1 && $1 =~ ^[0-9]+$  ]];	#If the first argument is provided and a number, use as number of lines specified
	then
		N=$1
	elif [[ -n $2 && $2 =~ ^[0-9]+$  ]]	#If the second argument is provided and a number, use as number of lines specified 
	then								#(WHEN ARG1 AND ARG2 ARE GIVEN BUT ARG1 IS NOT A REAL FOLDER)
		N=$2; 
	else 									 #if not default to 0
		N=0									
	fi

echo Number of lines specified: $N.
#######################################################################################################################
# Print the number of files in the folder being searched
#######################################################################################################################

	if [[ $n_files -gt 1 ]];				# > 1 files
	then 
		echo "There are $n_files fasta files.";
	elif [[ $n_files -eq 1 ]];				# Single file
	then 
		echo "There is 1 fasta file."; 
	else									# No files
		echo "There are no fasta files.";
	fi;
	
#######################################################################################################################
# Print all fasta sequence identifiers (first element of the fasta header)
#######################################################################################################################

echo All fasta identifiers in $name_folder:

	for i in $fastafiles;
	do
		echo $(grep ">" $i | sed 's/^>//' | awk '{print $1}' | sort | uniq ) 
		#For readability mantain echo $() to flatten the output
	done
	
#######################################################################################################################
# Print a header and contents for each fasta file 
#######################################################################################################################

	for i in $fastafiles;	#For each file the header contains:
	do
			#Name of file
			filename=$(echo "$i"| awk '{split($0, str, "/"); print str[length(str)]}') 
			#Wether it is a symlink
			symlnk=$( [[ -h $i ]] && echo "YES" || echo "NO") 
			#Number of sequences
			numberseq=$(grep -c ">" "$i" ) 
			#Total length of the sequences excluding "-", spaces, newline characters.
			seqlength=$(awk -v ORS="" '!/>/ {print}' "$i" | sed 's/[- ]//g' | wc -c)  
			#Wether the sequence contains nucleotides or aminoacids
			seq_nuc=$(grep -v ">" $i | grep '[atgcunATGCUN]')
			seq_prot=$(grep -v ">" $i | grep '[^atgcnuATGCNU]') 
				if [[ -n $seq_nuc && -n $seq_prot ]]; then 
					seq_type=Aminoacid
				elif [[ -n $seq_nuc ]]; then 
					seq_type=Nucleotide
				else 
					seq_type=Unknown
				fi

		#Print header
		echo " "
		echo /// FILE NAME: $filename 
		echo /// SYMLINK: $symlnk /// NUMBER OF SEQUENCES: $numberseq /// TOTAL SEQUENCE LENGTH: $seqlength /// TYPE OF SEQUENCE: $seq_type 
		echo " "

		#Print contents depending on the number of lines the file has and the number specified.
		n_lines=$(cat "$i" | wc -l)
		if [[ n_lines -le $(( 2*$N )) ]];	#if the file has 2N lines or fewer, display full content.
		then 
		cat "$i";
		elif [[ $N -eq 0 ]] 				#if no N is specified, skip step.
		then
			continue
		else 								#else print first N lines, then "...", then last N lines.
		head -n $N "$i"
		echo "..."
		tail -n $N "$i"
		fi;

	done
