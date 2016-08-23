#ifndef __NFLOG_COMMON__
#define __NFLOG_COMMON__

#ifdef __cplusplus
extern "C" {
#endif

enum CfgFlags {
        CfgSeq       = NFULNL_CFG_F_SEQ,
        CfgSeqGlobal = NFULNL_CFG_F_SEQ_GLOBAL,
};

extern void raise_swig_error(const char *errstr);

int  swig_nflog_callback(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
                       struct nflog_data *nfad, void *data);

const char * nflog_bindings_version(void);

int log_open(struct log *self);

void log_close(struct log *self);

int log_bind(struct log *self, int af_family);

int log_unbind(struct log *self, int af_family);

int log_set_bufsiz(struct log *self, int maxlen);
int log_set_qthresh(struct log *self, uint32_t qthresh);
int log_set_timeout(struct log *self, uint32_t timeout);
int log_set_flags(struct log *self, enum CfgFlags flags);

int log_create_queue(struct log *self, int queue_num);

int log_fast_open(struct log *self, int queue_num, int af_family);

int log_prepare(struct log *self);

int log_stop_loop(struct log *self);

int log_payload_get_nfmark(struct log_payload *self);

int log_payload_get_indev(struct log_payload *self);
int log_payload_get_physindev(struct log_payload *self);
int log_payload_get_outdev(struct log_payload *self);
int log_payload_get_physoutdev(struct log_payload *self);

uint32_t log_payload_get_uid(struct log_payload *self);
uint32_t log_payload_get_gid(struct log_payload *self);
uint32_t log_payload_get_seq(struct log_payload *self);
uint32_t log_payload_get_seq_global(struct log_payload *self);

const char * log_payload_get_prefix(struct log_payload *self);

uint16_t log_payload_get_hwtype(struct log_payload *self);

#ifdef __cplusplus
}
#endif

#endif /* __NFLOG_COMMON__ */
