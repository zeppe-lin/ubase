NAME      = ubase
VERSION   = 0.0

PREFIX    = /usr/local
MANPREFIX = $(PREFIX)/share/man

CC       ?= cc
AR       ?= ar
RANLIB   ?= ranlib

CPPFLAGS  = -D_FILE_OFFSET_BITS=64 -D_XOPEN_SOURCE=700 -D_GNU_SOURCE
CFLAGS   += -std=c99 -Wall -Wextra
LDLIBS   += -lcrypt
#LDFLAGS  = -s

# End of file
