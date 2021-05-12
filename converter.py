import sys
import json
import xmltodict

try:
	# read xml content
	f = open(sys.argv[1])
	xml_content = f.read()
	f.close()
	
	try:
		# write json file
		with open(sys.argv[2], 'w', encoding='utf-8') as f:
			json.dump(xmltodict.parse(xml_content), f, indent=4, sort_keys=True)
	except:
		print("[-] something wrong with {}. File can't be parsed. ".format(sys.argv[2]))
except:
	print("[-] something wrong with {}. Maybe file is empty".format(sys.argv[1]))
