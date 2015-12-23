import os
import pwd
import grp
import nflog
import time
import socket


# GLOBALS
count = 0
l = None


def dropPrivileges( uid_name, gid_name):
    # Get the uid/gid from the name
    running_uid = pwd.getpwnam(uid_name).pw_uid
    running_gid = grp.getgrnam(gid_name).gr_gid

    # Remove group privileges
    os.setgroups([])

    # Try setting the new uid/gid
    os.setgid(running_gid)
    os.setuid(running_uid)

    # Ensure a very conservative umask
    old_umask = os.umask(077)
    print "now running as non-root: u=%s, g=%s" % (uid_name, gid_name)


def callback(pkt):
    try:
        global count
        count += 1
        payload = pkt.get_data()
        #time.sleep(0.2) # TODO: enable this to enforce SIGINT in callback
        print "callback #%06d - %d bytes" % (count, len(payload))
    except KeyboardInterrupt:
        global l
        print "SIGINT in callback(), calling stop_loop()"
        l.stop_loop()


def main():
    global l
    NFLOG_GROUP = 1 # TODO: adapt this; default = 0
    l = nflog.log()
    l.set_callback(callback)
    l.fast_open(NFLOG_GROUP, socket.AF_INET)
    l.prepare()
    # TODO: change this to users with reduced privileges on your system
    dropPrivileges('nobody', 'nogroup')
    print "calling loop()"
    try:
        l.loop()
    except KeyboardInterrupt:
        print "SIGINT caught in main thread"
        l.stop_loop()
        pass # normal; sometimes happens in callback handler, sometimes here
    finally:
        print "returned from loop(), will now tear down"
        #l.unbind(socket.AF_INET) # l.unbind() is privileged (requires root)
        l.close()


if __name__ == "__main__":
    main()
