include config.mk

.SUFFIXES:
.SUFFIXES: .o .c

HDR = \
	arg.h        \
	config.h     \
	passwd.h     \
	proc.h       \
	queue.h      \
	reboot.h     \
	rtc.h        \
	text.h       \
	util.h

LIBUTIL = libutil.a
LIBUTILSRC = \
	libutil/agetcwd.c        \
	libutil/agetline.c       \
	libutil/apathmax.c       \
	libutil/concat.c         \
	libutil/ealloc.c         \
	libutil/eprintf.c        \
	libutil/estrtol.c        \
	libutil/estrtoul.c       \
	libutil/explicit_bzero.c \
	libutil/passwd.c         \
	libutil/proc.c           \
	libutil/putword.c        \
	libutil/recurse.c        \
	libutil/strlcat.c        \
	libutil/strlcpy.c        \
	libutil/strtonum.c       \
	libutil/tty.c            \

LIB = $(LIBUTIL)

BIN1 = \
	chvt              \
	clear             \
	df                \
	dmesg             \
	eject             \
	fallocate         \
	free              \
	id                \
	last              \
	login             \
	mesg              \
	mountpoint        \
	pagesize          \
	passwd            \
	pidof             \
	ps                \
	pwdx              \
	respawn           \
	stat              \
	stty              \
	su                \
	truncate          \
	unshare           \
	uptime            \
	vtallow           \
	watch             \
	who               \

BIN8 = \
	blkdiscard        \
	ctrlaltdel        \
	freeramdisk       \
	fsfreeze          \
	getty             \
	halt              \
	hwclock           \
	insmod            \
	killall5          \
	lastlog           \
	lsmod             \
	lsusb             \
	mkswap            \
	mount             \
	nologin           \
	pivot_root        \
	readahead         \
	rmmod             \
	swaplabel         \
	swapoff           \
	swapon            \
	switch_root       \
	sysctl            \
	umount            \
	vmstat            \

MAN1 = \
	chvt.1            \
	clear.1           \
	df.1              \
	dmesg.1           \
	eject.1           \
	fallocate.1       \
	free.1            \
	id.1              \
	login.1           \
	mesg.1            \
	mountpoint.1      \
	pagesize.1        \
	passwd.1          \
	pidof.1           \
	ps.1              \
	pwdx.1            \
	respawn.1         \
	stat.1            \
	su.1              \
	truncate.1        \
	unshare.1         \
	uptime.1          \
	vtallow.1         \
	watch.1           \
	who.1             \

MAN8 = \
	ctrlaltdel.8      \
	freeramdisk.8     \
	fsfreeze.8        \
	getty.8           \
	halt.8            \
	hwclock.8         \
	insmod.8          \
	killall5.8        \
	lastlog.8         \
	lsmod.8           \
	lsusb.8           \
	mkswap.8          \
	mount.8           \
	nologin.8         \
	pivot_root.8      \
	readahead.8       \
	rmmod.8           \
	swaplabel.8       \
	swapoff.8         \
	swapon.8          \
	switch_root.8     \
	sysctl.8          \
	umount.8          \

LIBUTILOBJ = $(LIBUTILSRC:.c=.o)
OBJ = $(BIN1:=.o) $(BIN8:=.o) $(LIBUTILOBJ)
SRC = $(BIN1:=.c) $(BIN8:=.c)

all: $(BIN1) $(BIN8)

$(BIN1) $(BIN8): $(LIB)

$(OBJ): $(HDR) config.mk

config.h:
	cp config.def.h $@

.o:
	$(CC) $(LDFLAGS) -o $@ $< $(LIB) $(LDLIBS)

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

$(LIBUTIL): $(LIBUTILOBJ)
	$(AR) rc $@ $?
	$(RANLIB) $@

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(BIN1) $(DESTDIR)$(PREFIX)/bin
	cd $(DESTDIR)$(PREFIX)/bin  && chmod 755 $(BIN1)
	mkdir -p $(DESTDIR)$(PREFIX)/sbin
	cp -f $(BIN8) $(DESTDIR)$(PREFIX)/sbin
	cd $(DESTDIR)$(PREFIX)/sbin && chmod 755 $(BIN8)
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	for m in $(MAN1); do \
		sed "s/^\.Os ubase/.Os ubase $(VERSION)/g" < "$$m" \
		> $(DESTDIR)$(MANPREFIX)/man1/"$$m"; \
	done
	mkdir -p $(DESTDIR)$(MANPREFIX)/man8
	for m in $(MAN8); do \
		sed "s/^\.Os ubase/.Os ubase $(VERSION)/g" < "$$m" \
		> $(DESTDIR)$(MANPREFIX)/man8/"$$m"; \
	done
	cd $(DESTDIR)$(MANPREFIX)/man1 && chmod 644 $(MAN1)
	cd $(DESTDIR)$(MANPREFIX)/man8 && chmod 644 $(MAN8)

uninstall:
	cd $(DESTDIR)$(PREFIX)/bin  && rm -f $(BIN1)
	cd $(DESTDIR)$(PREFIX)/sbin && rm -f $(BIN8)
	cd $(DESTDIR)$(MANPREFIX)/man1 && rm -f $(MAN1)
	cd $(DESTDIR)$(MANPREFIX)/man8 && rm -f $(MAN8)

clean:
	rm -f $(BIN1) $(BIN8) $(OBJ) $(LIB)

.PHONY:
	all install uninstall clean
