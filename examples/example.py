#!/usr/bin/python

# need root privileges

import struct
import sys
from datetime import datetime

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
        try:
            tv = payload.get_timestamp()
            d = datetime.fromtimestamp(tv.tv_sec + (tv.tv_usec / 1000000.))
            print "  timestamp: ", d
        except RuntimeError, e:
            #print e.args[0]
            pass
        data = payload.get_data()
        pkt = ip.IP(data)
        if pkt.p == ip.IP_PROTO_ICMP:
            print "  ICMP:  %s > %s type %d code %d" % (inet_ntoa(pkt.src),inet_ntoa(pkt.dst),pkt.icmp.type,pkt.icmp.code)
        elif pkt.p == ip.IP_PROTO_TCP:
            print "  TCP:  %s:%d > %s:%d" % (inet_ntoa(pkt.src),pkt.tcp.sport,inet_ntoa(pkt.dst),pkt.tcp.dport)
        elif pkt.p == ip.IP_PROTO_UDP:
            print "  UDP:  %s:%d > %s:%d" % (inet_ntoa(pkt.src),pkt.udp.sport,inet_ntoa(pkt.dst),pkt.udp.dport)
        else:
            print "  unknown proto %d:  %s > %s" % (pkt.p,inet_ntoa(pkt.src),inet_ntoa(pkt.dst))

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

