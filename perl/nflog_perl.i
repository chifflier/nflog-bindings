
// Grab a Perl function object as a Perl object.
%typemap(in) void *perl_cb {
  SV *obj = $input;
  if (SvROK(obj)) {
        obj = SvRV($input);
  }
  if (SvTYPE(obj) != SVt_PVCV) {
          SWIG_Error(SWIG_TypeError, "Parameter is not a function"); 
          return;
  }
  $1 = obj;
}

%{
#include <arpa/inet.h>
#include <linux/netfilter.h>
#include <linux/ip.h>

#include "nflog_utils.h"

int  swig_nflog_callback(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
                       struct nflog_data *nfad, void *data)
{
        int id = 0;
        struct nfulnl_msg_packet_hdr *ph;
        int ret;
        char *payload_data;
        int payload_len;
        struct timeval tv1, tv2, diff;

        if (data == NULL) {
                fprintf(stderr,"No callback set !\n");
                return -1;
        }

        ph = nflog_get_msg_packet_hdr(nfad);
        /*
        if (ph){
                id = ntohl(ph->packet_id);
        }
        */

        ret = nflog_get_payload(nfad, &payload_data);
        payload_len = ret;

        gettimeofday(&tv1, NULL);

        /*printf("callback called\n");
        printf("callback argument: %p\n",data);*/

        {
                SV *func = (SV*)data;
                struct log_payload *p;
                SV * payload_obj;

                dSP ;
                ENTER ;
                SAVETMPS ;

                PUSHMARK(SP) ;

                p = malloc(sizeof(struct log_payload));
                p->data = payload_data;
                p->len = payload_len;
                p->id = id;
                p->gh = gh;
                p->nfad = nfad;
                payload_obj = sv_newmortal();
                SWIG_MakePtr(payload_obj, (void*) p, SWIGTYPE_p_log_payload, 0);
                XPUSHs(payload_obj);

                PUTBACK;

                call_sv(func, G_DISCARD);
                free(p);

                FREETMPS ;
                LEAVE ;
        }

        gettimeofday(&tv2, NULL);

        timeval_subtract(&diff, &tv2, &tv1);
        printf("perl callback call: %d sec %d usec\n",
                (int)diff.tv_sec,
                (int)diff.tv_usec);

        return 0;
}

void raise_swig_error(const char *errstr)
{
        fprintf(stderr,"ERROR %s\n",errstr);
        SWIG_Error(SWIG_RuntimeError, errstr); 
}
%}

%extend log {

int set_callback(void *perl_cb)
{
        self->_cb = (void*)perl_cb;
        return 0;
}

};

%typemap (out) const char* get_data {
        $result = sv_2mortal(newSVpvn($1,arg1->len)); // blah
        argvi++;
}

%extend log_payload {
const char* get_data(void) {
        return self->data;
}
};

