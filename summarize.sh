#!/usr/bin/env bash


# display usage
usage(){
   echo "Description: Script to summarize results of nmap into a .csv file."
   echo "Syntax: ./summarize.sh [-d|-h|-n|-u] -t TARGET"
   echo "	Necessary:"
   echo "		-t	Target IP. Can be a single IP, a CIDR or a file with one IP per line"
   echo "	Optional:"
   echo "		-d	Output dir. Default: ./output"
   echo "		-h	Print this usage guide"
   echo "		-n	Disable ping on host. All hosts will be tested"
   echo "		-u	Also test UDP ports. Default: only TCP ports are tested"
   echo
}

# default parameters
OUTPUT='./output'
CHECK_TARGETS_COMMAND='nmap -sn -n'
PORT_SCAN_COMMAND='nmap'

# check if args
if [ $# -eq 0 ]; then
	usage
	exit 0;
fi

# process command line arguments
while getopts "d:t:hnu" opt; do
	case ${opt} in
		d)
			OUTPUT=$OPTARG
			;;				
		h)
			usage
			exit 0
			;;
		n)
			CHECK_TARGETS_COMMAND=$CHECK_TARGETS_COMMAND' -Pn'
			;;
		t)
			TARGET=${OPTARG}
			;;
		u)
			PORT_SCAN_COMMAND=$PORT_SCAN_COMMAND' -sS -sU'
			;;
	esac
done

if [ -z "$TARGET" ]; then
	usage
	exit 0;
else
	# create OUTPUT if not exist
	[ -d $OUTPUT ] || mkdir -p $OUTPUT

	if [ ! -f $TARGET ]; then
		hosts_alive=$($CHECK_TARGETS_COMMAND $TARGET | grep report | awk '{print $5}')
	else
		hosts_alive=$($CHECK_TARGETS_COMMAND -iL $TARGET | grep report | awk '{print $5}')
	fi

	# iterate over each host in hosts_alive list and scan it's services
	for host in $hosts_alive; do
		# by default test each host
		TESTIT=1 
		
		# scan
		if [ -f $OUTPUT/$host.xml ]; then
			read -p "Overwrite $OUTPUT/$host.xml (y/n)?" ANSWER
			case $ANSWER in 
				[yY]) TESTIT=1 ;;
				[nN]) TESTIT=0 ;;
			esac
		fi

		if [ $TESTIT = 1 ]; then
			# execute nmap
			echo "[+] scanning ports/services on $host..."
			eval $PORT_SCAN_COMMAND "-Pn -sV -O -T5 -p- -oX $OUTPUT/$host.xml $TARGET" >/dev/null 2>&1
		fi

		# convert .xml files to .json using converter.py script
		if [ -f "$OUTPUT/$host.xml" ]; then
			echo "[+] converting $host.xml to .json"
			python3 converter.py "$OUTPUT/$host.xml" "$OUTPUT/$host.json"
		else
			echo "[-] error trying convert $host.xml file"
		fi
		
	done

	# summarize results
	if [ -f "$OUTPUT/"*.json ]; then
		echo "[+] summarizing results into $OUTPUT/summarized_results.csv"
		python3 parser.py "$OUTPUT/"*.json >> "$OUTPUT/summarized_results.csv"
		echo "[+] done!"
	else
		echo "[-] error trying summarize. Maybe file aren't into $OUTPUT dir."
	fi
fi
