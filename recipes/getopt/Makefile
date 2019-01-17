.SUFFIXES:

DESTDIR=
prefix=
bindir=$(prefix)/bin
mandir=$(prefix)/man
man1dir=$(mandir)/man1
sharedir=$(prefix)/share
getoptdir=$(sharedir)/getopt
localedir=$(sharedir)/locale

# Define this to 0 to use the getopt(3) routines in this package.
LIBCGETOPT=1

# Define this to 1 if you do not have the gettext routines
WITHOUT_GETTEXT=1

# For creating the archive
PACKAGE="${pkgname}"
VERSION="${pkgver}"
BASENAME=$(PACKAGE)-$(VERSION)
UNLIKELYNAME=a8vwjfd92

SHELL=/bin/sh

RM=rm -f
INSTALL=install
MSGFMT=msgfmt

LANGUAGES = ca cs da de es et eu fi fr gl hr hu id it ja nl pl pt_BR ru sl sv tr uk vi zh_CN zh_TW
MOFILES:=$(patsubst %,po/%.mo,$(LANGUAGES))

CPPFLAGS += -DLIBCGETOPT=$(LIBCGETOPT) -DWITHOUT_GETTEXT=$(WITHOUT_GETTEXT) -DLOCALEDIR=\"$(localedir)\" -DNOT_UTIL_LINUX -Dprogram_invocation_short_name=\"$(PACKAGE)\"  -Dprogram_version=\"$(VERSION)\"
ifeq ($(LIBCGETOPT),0)
CPPFLAGS+=-I./gnu 
endif
CFLAGS += -includelocale.h

sources=getopt.c
ifeq ($(LIBCGETOPT),0)
sources+=gnu/getopt.c gnu/getopt1.c
endif

objects=$(sources:.c=.o)

binaries=getopt

.PHONY: all clean realclean 
all: $(binaries) all_po

clean: clean_po
	-$(RM) $(objects) $(binaries) 

getopt: $(objects)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $(objects)

install: getopt install_po
	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
	$(INSTALL) -m 755 getopt $(DESTDIR)$(bindir)
	$(INSTALL) -m 644 getopt.1 $(DESTDIR)$(man1dir)

install_doc:
	$(INSTALL) -m 755 -d $(DESTDIR)$(getoptdir)
	$(INSTALL) -m 755 getopt-parse.bash getopt-parse.tcsh \
	                  getopt-test.bash getopt-test.tcsh \
	           $(DESTDIR)$(getoptdir)

ifeq ($(WITHOUT_GETTEXT),0)
all_po: $(MOFILES)
install_po: all_po
	$(INSTALL) -m 755 -d $(DESTDIR)$(localedir)
	for lang in $(LANGUAGES) ; do \
	  dir=$(localedir)/$$lang/LC_MESSAGES; \
	  $(INSTALL) -m 755 -d $(DESTDIR)$$dir ;\
	  $(INSTALL) -m 644 po/$$lang.mo $(DESTDIR)$$dir/getopt.mo  ;\
	done
clean_po:
	$(RM) $(MOFILES)
else
all_po:
install_po:
clean_po:
endif

%.o: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $*.c -o $*.o

%.mo: %.po
	 $(MSGFMT) -o $@ $<

# You need GNU tar for this to work!
.PHONY: package
package: clean
	$(RM) -r $(UNLIKELYNAME)
	mkdir $(UNLIKELYNAME)
	ln -s .. $(UNLIKELYNAME)/$(BASENAME)
	cd $(UNLIKELYNAME) && tar cfvzp ../$(BASENAME).tar.gz --exclude='CVS' --exclude='*.tar.gz' --exclude=$(UNLIKELYNAME) $(BASENAME)/*
	$(RM) -r $(UNLIKELYNAME)

.PHONY: test
test: all
	./run-tests
