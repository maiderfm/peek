#!/usr/bin/bash

if [[ -z $2 ]];
then
	n_lines=3;
else
	n_lines=$2;
fi;

text_lines=$(cat "$1" | wc -l);

if [[ $text_lines -le 2*$n_lines ]];
then
	cat "$1"
else
	echo "Warning: Number of lines in file is greater than twice the requested number of lines";
	head -n $n_lines "$1";
	echo "...";
	tail -n $n_lines "$1";
fi;

