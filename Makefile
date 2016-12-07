GITVER := $(shell git rev-parse --short HEAD)
VERSION = 0.22
PREFIX ?= /usr/local
SBINDIR ?= $(PREFIX)/sbin
SHAREDIR ?= $(PREFIX)/share
DRACUTMODDIR ?= $(PREFIX)/lib/dracut/modules.d/01vmklive

SHIN    += $(shell find -type f -name '*.sh.in')
SCRIPTS += $(SHIN:.sh.in=.sh)

%.sh: %.sh.in
	 sed -e "s|@@MKLIVE_VERSION@@|$(VERSION) $(GITVER)|g" $^ > $@
	 chmod +x $@

all: $(SCRIPTS)

install: all
	@echo "This is not supported..."
	@exit 1

clean:
	@echo "This is not supported..."
	@exit 1

dist:
	@echo "Building distribution tarball for tag: v$(VERSION) ..."
	-@git archive --format=tar --prefix=void-live-$(VERSION)/ \
		v$(VERSION) | xz -9 > ~/void-live-$(VERSION).tar.xz

.PHONY: all clean install dist
