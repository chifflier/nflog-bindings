#!/usr/bin/python

# need root privileges

import struct
import sys
import time

from socket import AF_INET, AF_INET6, inet_ntoa

sys.path.append('python')
sys.path.append('build/python')
import nflog

sys.path.append('dpkt-1.6')
from dpkt import ip

def cb(i,payload):
	print "python callback called !", i

	print "payload len ", payload.get_length()
	data = payload.get_data()
	pkt = ip.IP(data)
	print "proto:", pkt.p
	print "source: %s" % inet_ntoa(pkt.src)
	print "dest: %s" % inet_ntoa(pkt.dst)
	if pkt.p == ip.IP_PROTO_TCP:
	 	print "  sport: %s" % pkt.tcp.sport
	 	print "  dport: %s" % pkt.tcp.dport

	sys.stdout.flush()
	return 1

l = nflog.log()

print "open"
l.open()

print "bind"
l.bind();

#print "setting callback (should fail, wrong arg type)"
#try:
#	q.set_callback("blah")
#except TypeError, e:
#	print "type failure (expected), continuing"

print "setting callback"
l.set_callback(cb)

print "creating queue"
l.create_queue(1)

print "trying to run"
try:
	l.try_run()
except KeyboardInterrupt, e:
	print "interrupted"


print "unbind"
l.unbind()

print "close"
l.close()

