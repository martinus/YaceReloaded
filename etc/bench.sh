#!/bin/sh

function benchmark() {
	local RUNS=$1
	local PROG1=$2
	local PROG2=$3
	WARRIORS=`find warriors -name "*.red"|grep -v "error"|sort`
	WARRIORS2=${WARRIORS}\

	echo -e "% $PROG2 is faster | time $PROG1 | time $PROG2 | warrior1 | warrior2"
	for W1 in $WARRIORS ; do
		for W2 in $WARRIORS2 ; do
			TIME1=`(time $PROG1 -bkF 4000 -r $RUNS "${W1}" "${W2}" &>O1$$~) 2>&1`
			TIME2=`(time $PROG2 -bkF 4000 -r $RUNS "${W1}" "${W2}" &>O2$$~) 2>&1`
			diff O1$$~ O2$$~
			rm -f O1$$~ O2$$~
			FASTER=`echo "scale=5; (${TIME1}/${TIME2}-1)*100" |bc`
			echo -e "${FASTER}\t|\t${TIME1}\t|\t${TIME2}\t|\t${W1}\t|\t${W2}"
		done
	done
}


if [ $# -eq 0 ]; then
	RUNS=200
else
	RUNS=$1
fi


TIMEFORMAT="%U"
benchmark $RUNS pmars ./exmars
