#ifndef __NFLOG_H__
#define __NFLOG_H__

#include <sys/types.h> /* we need u_int16_t for nflog */

#include <libnetfilter_log/libnetfilter_log.h>

struct log {
	int dummy;

	struct nflog_handle *_h;
	struct nflog_g_handle *_gh;
	int fd;
	void *_cb;
};

struct log_payload {
	char *data;
	unsigned int len;
	int id;
	struct nflog_g_handle *gh;
	struct nflog_data *nfad;
};

#endif /* __NFLOG_H__ */
