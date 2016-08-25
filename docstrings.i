// ************* log ******************


%feature("docstring") log::open "Opens a NFLOG handler

This function obtains a netfilter log connection handle. When you are
finished with the handle returned by this function, you should destroy it
by calling `close()`.
A new netlink connection is obtained internally
and associated with the log connection handle returned."

%feature("docstring") log::close "Closes a NFLOG handler

This function closes the nflog handler and free associated resources."

%feature("docstring") log::bind "Bind a nflog handler to a given protocol family

Binds the given log connection handle to process packets belonging to
the given protocol family (ie. `PF_INET`, `PF_INET6`, etc).

Arguments

* `pf` - Protocol family (usually `AF_INET` or `AF_INET6`)

Remarks:

**Requires root privileges**"

%feature("docstring") log::unbind "Unbinds the nflog handler from a protocol family

Unbinds the given nflog handle from processing packets belonging to the
given protocol family.

Arguments

* `pf` - Protocol family (usually `AF_INET` or `AF_INET6`)

Remarks:

**Requires root privileges**"

%feature("docstring") log::create_queue "Binds a new handle to a specific group number.

Arguments:

* `num` - The number of the group to bind to

Remarks:

**The callback must be registered before calling this function**"

%feature("docstring") log::fast_open "Bind family and group

This function is a wrapper around `bind()` and `create_queue()`

Remarks:

**The callback must be registered before calling this function**"

%feature("docstring") log::set_callback "Registers the callback triggered when a packet is received

The callback must a valid function in the target language, with the correct prototype."

%feature("docstring") log::set_bufsiz "Sets the size of the nflog buffer for this group

Arguments:

* `nlbufsiz` - Size of the nflog buffer

This function sets the size (in bytes) of the buffer that is used to
stack log messages in nflog."

%feature("docstring") log::set_qthresh "Sets the maximum amount of logs in buffer for this group

Arguments:

* `qthresh` - Maximum number of log entries

This function determines the maximum number of log entries in the
buffer until it is pushed to userspace."

%feature("docstring") log::set_timeout "Sets the maximum time to push log buffer for this group

Arguments:

* `timeout` - Time to wait until the log buffer is pushed to userspace

This function allows to set the maximum time that nflog waits until it
pushes the log buffer to userspace if no new logged packets have occured.

Basically, nflog implements a buffer to reduce the computational cost of
delivering the log message to userspace."

%feature("docstring") log::set_flags "Sets the nflog flags for this group

Arguments:

* `flags` - Flags that you want to set

There are two existing flags (see the `CfgFlags` struct):

* `CfgSeq`: This enables local nflog sequence numbering.
* `CfgSeqGlobal`: This enables global nflog sequence numbering."

%feature("docstring") log::prepare "Prepare queue before waiting for packets

Run the following preparation steps:

* set the CopyPacket mode (copy the full packet)
* call `setsockopt(NETLINK_NO_ENOBUFS)` to avoid interrupting `loop()` when
  the queue is full

Calling this function is not mandatory, but may help in some cases"

%feature("docstring") log::loop "Runs an infinite loop, waiting for packets and triggering the callback."

%feature("docstring") log::stop_loop "Stops the infinite loop"

// ************* log_payload ******************

%feature("docstring") log_payload::get_nfmark "Get the packet mark"
%feature("docstring") log_payload::get_timestamp "Get the packet timestamp"

%feature("docstring") log_payload::get_indev "Get the interface that the packet was received through

Returns the index of the device the packet was received via.
If the returned index is 0, the packet was locally generated or the
input interface is not known (ie. `POSTROUTING`?)."

%feature("docstring") log_payload::get_physindev "Get the physical interface that the packet was received through

Returns the index of the physical device the packet was received via.
If the returned index is 0, the packet was locally generated or the
physical input interface is no longer known (ie. `POSTROUTING`?)."

%feature("docstring") log_payload::get_outdev "Get the interface that the packet will be routed out

Returns the index of the device the packet will be sent out.
If the returned index is 0, the packet is destined to localhost or
the output interface is not yet known (ie. `PREROUTING`?)."

%feature("docstring") log_payload::get_physoutdev "Get the physical interface that the packet will be routed out

Returns the index of the physical device the packet will be sent out.
If the returned index is 0, the packet is destined to localhost or
the physical output interface is not yet known (ie. `PREROUTING`?)."

%feature("docstring") log_payload::get_uid "Get the UID of the user that has generated the packet

Available only for outgoing packets"

%feature("docstring") log_payload::get_gid "Get the GID of the user that has generated the packet

Available only for outgoing packets"

%feature("docstring") log_payload::get_seq "Get the local nflog sequence number

You must enable this via `set_flags(nflog::CfgFlags::CfgFlagsSeq)`."

%feature("docstring") log_payload::get_seq_global "Get the global nflog sequence number

You must enable this via `set_flags(nflog::CfgFlags::CfgFlagsSeqGlobal)`."

%feature("docstring") log_payload::get_length "Get the length of the packet contents"

%feature("docstring") log_payload::get_data "Get the packet contents"

%feature("docstring") log_payload::get_prefix "Return the log prefix as configured using `--nflog-prefix \"...\" in iptables rules."

%feature("docstring") log_payload::get_hwtype "Get the hardware link layer type from logging data"
%feature("docstring") log_payload::get_hwhdr "Get the hardware link layer header"
