import sys
import json


# csv header
print("IP,SO,PORTA/SERVICO")

# get json file name
for file in sys.argv[1:]:

	# read file
	with open(file, 'r', encoding='utf-8') as f:
		# if can't read file, go to next
		try:
			result = json.load(f)
		except:
			print("{},Verifique o arquivo .json relacionado a este IP,".format(str(file.split('/')[-1].split('.json')[0])))
			continue

		# ip
		try:
			try:
				for addr in result['nmaprun']['host']['address']:
					if addr['@addrtype'] == 'ipv4':
						ip = addr['@addr']

						break
			except:
				ip = result['nmaprun']['host']['address'][0]['@addr']
		
			# name
			try:
				if type(result['nmaprun']['host']['os']['osmatch']) == dict:
					os_name = result['nmaprun']['host']['os']['osmatch']['@name']
				else:
					os_name = result['nmaprun']['host']['os']['osmatch'][0]['@name']				
			except:
				os_name = "Desconhecido"


			# type
			try:
				if type(result['nmaprun']['host']['os']['osmatch']) == dict:
					osclass = result['nmaprun']['host']['os']['osmatch']['osclass']
				else:
					osclass = result['nmaprun']['host']['os']['osmatch'][0]['osclass']

				try:
					os_type = " ({})".format(osclass['@type'])

				except:
					os_type = " ({})".format(osclass[0]['@type'])
			except:
				os_type = ""

			# ports
			try:
				services = result['nmaprun']['host']['ports']['port']
			except:
				services = "Nenhuma porta encontrada"

			if type(services) == list:
				for service in services:
					port = service['@portid']
					protocol = service['@protocol']

					try:
						service_name = "({})".format(service['service']['@name'])
					except:
						service_name = ""

					try:
						product_name = "- {}".format(service['service']['@product'])
					except:
						product_name = ""

					#print(f"IP: {ip}\t\tSO: {name} {os_type}\t\tPort: {port}:{protocol} {service_name} {product_name}")
					print("{},{}{},{}:{} {} {}".format(ip, os_name, os_type, port, protocol, service_name, product_name))


			elif type(services) == dict:
				port = service['@portid']
				protocol = service['@protocol']

				try:
					service_name = "({})".format(service['service']['@name'])
				except:
					service_name = ""

				try:
					product_name = "- {}".format(service['service']['@product'])
				except:
					product_name = ""

				print("{},{}{},{}:{} {} {}".format(ip, os_name, os_type, port, protocol, service_name, product_name))
			else:
				print("{},{}{},{}".format(ip, os_name, os_type, services))
		except: 
			print("{},Verifique o arquivo .xml ou .json relacionado a este IP,".format(str(file.split('/')[-1].split('.json')[0])))

