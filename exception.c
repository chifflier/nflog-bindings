
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exception.h>

extern void raise_swig_error(const char *errstr);

static char error_message[256];
static int error_status = 0;

void throw_exception(char *msg) {
        strncpy(error_message,msg,255);
        error_message[255] = 0;
        raise_swig_error(error_message);
        error_status = 1;
}

void clear_exception() {
        error_status = 0;
}

char *check_exception() {
        if (error_status) {
                return error_message;
        } else {
                return NULL;
        }
}

