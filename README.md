# nmap-summarize-results

### Description

Script to summarize results of nmap into a .csv file.

### Install 

#### Clone this repo

	git clone

#### Install ependencies

	pip install -r requiments.txt

#### Syntax

	./summarize.sh [-d|-h|-n|-u] -t TARGET

#### Arguments

	Required:
		-t	Target IP. Can be a single IP, a CIDR or a file with one IP per line
	Optional:
		-d	Output dir. Default: ./output
		-h	Print this usage guide
		-n	Disable ping on host. All hosts will be tested
		-u	Also test UDP ports. Default: only TCP ports are tested

#### Examples

* Verify wich hosts are alive into a IP range and enumerate they TCP open ports. Default setup.

      ./summarize.sh -t 192.168.0.1/25

* Verify all hosts. Don't performe ping to check which of them are alive. 

      ./summarize.sh -n -t 192.168.10.1/24
      
* Enumerate TCP and UDP ports of alive hosts.

      ./summarize.sh -u -t 192.168.7.1/25
      
* Define an output diretory where the files will be saved. Default: ./output.

      ./summarize.sh -d results -t 10.10.0.1/24
      
* Pass a list of IPs into a file.
      
      List IPs into a file (ips.txt):
       		192.168.0.10
       		192.168.0.110
       		192.168.0.235
       		192.168.0.244
       		192.168.0.250
       
       ./summarize.sh -d results -t ips.txt
   
