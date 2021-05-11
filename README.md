# nmap-summarize-results

## Usage:
Description: Script to summarize results of nmap into a .csv file.
Syntax: ./summarize.sh [-d|-h|-n|-u] -t TARGET
	Necessary:
		-t	Target IP. Can be a single IP, a CIDR or a file with one IP per line
	Optional:
		-d	Output dir. Default: ./output
		-h	Print this usage guide
		-n	Disable ping on host. All hosts will be tested
		-u	Also test UDP ports. Default: only TCP ports are tested
