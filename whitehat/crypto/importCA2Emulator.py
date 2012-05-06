#!/usr/bin/python

import sqlite3
import os
import subprocess
from optparse import OptionParser

__usage__ = """
Please supply required arguments: <CA Certificate Path>

    add_ca_to_emulator.py <CA Certificate Path>
"""

simulator_dir = os.getenv('HOME')+"/Library/Application Support/iPhone Simulator/"
truststore_path = "/Library/Keychains/TrustStore.sqlite3"


def cert_fingerprint_via_openssl(cert_location):
	output = subprocess.check_output(["openssl", "x509", "-noout", "-in", cert_location, "-fingerprint"])
	fingerprint_with_colons = output.split("=")[1]
	return fingerprint_with_colons.replace(':','')


def cert_fingerprint(cert_location):
	try:
		from M2Crypto import X509	
		cert = X509.load_cert(cert_location)
		return cert.get_fingerprint('sha1')
	except ImportError:
		return cert_fingerprint_via_openssl(cert_location)	


def add_to_truststore(sdk_dir, cert_fingerprint):
	tpath = simulator_dir+sdk_dir+truststore_path

	sha1="X'"+cert_fingerprint.strip()+"'"

	try:
		conn = sqlite3.connect(simulator_dir+sdk_dir+truststore_path)
		c = conn.cursor()
		sql = 'insert into tsettings values (%s,%s,%s,%s)'%(sha1, "randomblob(16)", "randomblob(16)", "randomblob(16)")
		c.execute(sql)
		conn.commit()

		c.close()
		conn.close()
		print("Successfully added CA to %s" % tpath) 
	except sqlite3.OperationalError:
		print("Error adding CA to %s" % tpath )
		print("Mostly likely failed because Truststore does not exist..skipping\n")
		return
	except sqlite3.IntegrityError:
		print("Error adding CA to %s" % tpath )
		print("Table already has an entry with the same CA SHA1 fingerprint..skipping\n")
		return

if __name__ == "__main__":
	parser = OptionParser(usage=__usage__)
	opt, args = parser.parse_args()

	if len(args) < 1:
		parser.print_help()
		exit(1)

	cert_location = args[0]

	cert_fingerprint = cert_fingerprint(cert_location)

	for sdk_dir in os.listdir(simulator_dir):
		if not sdk_dir.startswith('.') and sdk_dir != 'User':
			add_to_truststore(sdk_dir, cert_fingerprint)
