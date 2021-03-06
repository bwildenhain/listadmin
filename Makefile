SHELL = /bin/sh
# a BSD or GNU style install is required, e.g., /usr/ucb/install on Solaris
INSTALL = install

VERSION = $(shell perl listadmin.pl --version|cut -f3 -d ' ')

PREFIX = /usr/local
prefix = $(PREFIX)
bindir = $(prefix)/bin
mandir = $(prefix)/share/man

SRCFILES = Makefile listadmin.pl listadmin.1 ChangeLog sample-session.txt INSTALL

all:
	@echo Nothing needs to be done

install:
	$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m 755 listadmin.pl $(DESTDIR)$(bindir)/listadmin
	$(INSTALL) -m 644 listadmin.1 $(DESTDIR)$(mandir)/man1/listadmin.1

listadmin.txt: listadmin.1
	man ./$< | col -b > $@

TARFILE = listadmin-$(VERSION).tar.gz
$(TARFILE): $(SRCFILES) listadmin.txt
	@rm -rf listadmin-$(VERSION)
	mkdir listadmin-$(VERSION)
	cp $(SRCFILES) listadmin.txt listadmin-$(VERSION)/
	tar acf $(TARFILE) listadmin-$(VERSION)
	rm -rf listadmin-$(VERSION)

dist: $(TARFILE)

distclean:
	rm -rf $(TARFILE) listadmin.txt listadmin-$(VERSION)

# for my use only
upload:
	rsync -avh --progress $(TARFILE) solbu@frs.sourceforge.net:/home/frs/project/listadmin/$(VERSION)/

.PHONY: listadmin.txt
