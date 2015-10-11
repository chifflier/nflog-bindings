%module nflog

%{
#include <nflog.h>

#include <nflog_common.h>

#include <exception.h>
%}

%include exception.i




#if defined(SWIGPYTHON)

%include python/nflog_python.i

#elif defined(SWIGPERL)

%include perl/nflog_perl.i

#endif


%extend log {

%exception {
        char *err;
        clear_exception();
        $action
        if ((err = check_exception())) {
                SWIG_exception(SWIG_RuntimeError, err);
        }
}

        int open();
        void close();
        int bind(int);
        int unbind(int);
        int create_queue(int);
        int fast_open(int, int);
        int set_bufsiz(int);
        int try_run();
};

%extend log_payload {
        int get_nfmark();
        int get_indev();
        int get_outdev();
	int get_uid();
	int get_gid();

unsigned int get_length(void) {
        return self->len;
}

};



%include "nflog.h"

const char * log_bindings_version(void);

