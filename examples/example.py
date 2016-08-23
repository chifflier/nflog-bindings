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

l = nflog.log()

def cb(payload):
    try:
        print "Packet received"
        print "seq: [%d]" % payload.get_seq()

        print "  payload len ", payload.get_length()
        data = payload.get_data()
        pkt = ip.IP(data)
        print "  proto:", pkt.p
        print "  source: %s" % inet_ntoa(pkt.src)
        print "  dest: %s" % inet_ntoa(pkt.dst)
        if pkt.p == ip.IP_PROTO_TCP:
            print "    sport: %s" % pkt.tcp.sport
            print "    dport: %s" % pkt.tcp.dport

        sys.stdout.flush()
        return 1
    except KeyboardInterrupt:
        print "interrupted in callback"
        global l
        print "stop the loop"
        l.stop_loop()

print "setting callback"
l.set_callback(cb)

print "open"
l.fast_open(1, AF_INET)
l.set_flags(nflog.CfgSeq)

print "prepare"
l.prepare()

print "loop nflog device until SIGINT"
try:
    l.loop()
except KeyboardInterrupt, e:
	print "loop() was interrupted"


print "unbind"
l.unbind(AF_INET)

print "close"
l.close()

