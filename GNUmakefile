# -*-Makefile-*-
# WARNING WARNING WARNING
# do not edit! this is GNUmakefile, generated from GNUmakefile.in
# -*-Makefile-*-

depth = .

SUBDIRS = buildscripts python scripts \
	flower lily \
	mf ly \
	tex ps scm \
	po make \
	elisp vim \
	input \
	stepmake $(documentation-dir)


## this convoluted construction is necessary, since we don't know the
## value of DOCUMENTATION here.
documentation-dir=$(if $(findstring no,$(DOCUMENTATION)),,Documentation)

SCRIPTS = configure autogen.sh 
README_FILES = ChangeLog COPYING DEDICATION ROADMAP THANKS HACKING
TOPDOC_FILES=AUTHORS README INSTALL NEWS
TOPDOC_TXT_FILES = $(addprefix $(top-build-dir)/Documentation/topdocs/$(outdir)/,$(addsuffix .txt,$(TOPDOC_FILES)))
IN_FILES := $(call src-wildcard,*.in)

EXTRA_DIST_FILES = VERSION .cvsignore .gitignore SConstruct \
  $(README_FILES) $(SCRIPTS) $(IN_FILES) 
INSTALLATION_DIR=$(local_lilypond_datadir)
INSTALLATION_FILES=$(config_make) VERSION

# bootstrap stepmake:
#
STEPMAKE_TEMPLATES=toplevel po install
include $(depth)/make/stepmake.make

local-dist: dist-toplevel-txt-files 

default: $(outdir)/VERSION

$(outdir)/VERSION: $(config_make)
	echo $(TOPLEVEL_VERSION) > $@

dist-toplevel-txt-files:
	-mkdir -p $(distdir)
	ln $(TOPDOC_TXT_FILES) $(distdir)/
	ln $(top-src-dir)/stepmake/aclocal.m4 $(distdir)/

doc: 
	$(MAKE) -C Documentation

install-WWW:
	-$(INSTALL) -m 755 -d $(DESTDIR)$(webdir)
	cp -a $(outdir)/web-root/ $(DESTDIR)$(webdir)/

	$(MAKE) -C Documentation/user local-install-WWW
	$(MAKE) -C Documentation/user install-info

install-help2man:
	$(MAKE) -C scripts man install-help2man
	$(MAKE) -C lily man install-help2man

web-install:
	$(MAKE) out=www install-WWW

uninstall-WWW:
	echo TODO

web-uninstall:
	$(MAKE) out=www uninstall-WWW

local-install:
	$(INSTALL) -d $(DESTDIR)$(local_lilypond_datadir)

final-install:
	@true

web-ext = html midi pdf png txt ly signature

footify = $(PYTHON) $(step-bindir)/add-html-footer.py  --name $(PACKAGE_NAME) --version $(TOPLEVEL_VERSION)
footifymail = MAILADDRESS='http://post.gmane.org/post.php?group=gmane.comp.gnu.lilypond.bugs'



local-WWW-post:
# need UTF8 setting in case this is hosted on a website. 
	echo -e 'AddDefaultCharset utf-8\nAddCharset utf-8 .html\nAddCharset utf-8 .en\nAddCharset utf-8 .nl\nAddCharset utf-8 .txt\n' > $(top-build-dir)/.htaccess
	$(PYTHON) $(buildscript-dir)/mutopia-index.py -o $(outdir)/examples.html input/
	echo '<META HTTP-EQUIV="refresh" content="0;URL=Documentation/index.html">' > $(outdir)/index.html
	echo '<html><body>Redirecting to the documentation index...</body></html>' >> $(outdir)/index.html

	cd $(top-build-dir) && $(FIND) . -name '*.html' -print | $(footifymail) xargs $(footify)

	cd $(top-build-dir) && find Documentation input \
		$(web-ext:%=-path '*/out-www/*.%' -or) -type l \
		| grep -v 'lily-[0-9].*.pdf' \
		| grep -v '/fr/' \
		> $(outdir)/weblist
	ls $(outdir)/*.html >> $(outdir)/weblist

## urg: this is too hairy, should write a python script to do this.

## rewrite file names so we lose out-www
	rm -rf $(outdir)/web-root/ 
	mkdir $(outdir)/web-root/
## urg slow.
	cat $(outdir)/weblist | (cd $(top-build-dir); tar -cf-  -T- ) | \
		tar -C $(outdir)/web-root/ -xf -  
	for dir in $(outdir)/web-root/ ; do  \
		cd $$dir && \
		for a in `find . -name out-www`; do \
			rsync -a  --link-dest $$a/ $$a/ $$a/.. ; \
			rm -rf $$a ; \
		done \
	done
	echo $(TOPLEVEL_VERSION) > $(outdir)/web-root/VERSION

tree-prefix = $(outdir)
tree-bin = $(tree-prefix)/bin
tree-lib = $(tree-prefix)/lib
tree-share = $(tree-prefix)/share
tree-share-prefix = $(tree-share)/lilypond/$(TOPLEVEL_VERSION)
tree-share-prefix-current = $(tree-share)/lilypond/current
tree-lib-prefix = $(tree-lib)/lilypond/$(TOPLEVEL_VERSION)
tree-lib-prefix-current = $(tree-lib)/lilypond/current

C_DIRS = flower lily
c-clean:
	$(foreach i, $(C_DIRS), $(MAKE) -C $(i) clean &&) true

src-ext = c cc yy ll hh icc py scm tex ps texi itexi tely itely sh

web-clean:
	$(MAKE) out=www clean
	$(MAKE) $(tree-share-prefix)/lilypond-force

default: $(config_h) build-dir-setup 

build-dir-setup: $(tree-share-prefix)/lilypond-force

PO_FILES = $(call src-wildcard,$(src-depth)/po/*.po)
HELP_CATALOGS = $(PO_FILES:po/%.po=%)
CATALOGS = $(HELP_CATALOGS:lilypond=) 

$(tree-share-prefix)/lilypond-force link-tree: GNUmakefile
# Preparing LilyPond tree for build-dir exec
	cd $(top-build-dir)/$(outbase) && rm -rf bin lib share
	mkdir -p $(tree-bin)
	mkdir -p $(tree-share-prefix)
	ln -s $(TOPLEVEL_VERSION) $(tree-share-prefix-current)
	mkdir -p $(tree-lib-prefix)
	ln -s $(TOPLEVEL_VERSION) $(tree-lib-prefix-current)
	mkdir -p $(tree-share-prefix)/dvips
	mkdir -p $(tree-share-prefix)/elisp
	mkdir -p $(tree-share-prefix)/fonts
	mkdir -p $(tree-share-prefix)/fonts/otf
	mkdir -p $(tree-share-prefix)/fonts/tfm
	mkdir -p $(tree-share-prefix)/fonts/type1
	mkdir -p $(tree-share-prefix)/fonts/svg
	mkdir -p $(tree-share-prefix)/fonts/map
	mkdir -p $(tree-share-prefix)/fonts/enc
	mkdir -p $(tree-share-prefix)/tex
	cd $(tree-bin) && \
		ln -sf ../../lily/$(outconfbase)/lilypond . && \
		for i in abc2ly convert-ly etf2ly lilypond-book lilypond-invoke-editor midi2ly musicxml2ly; \
			do ln -sf ../../scripts/$(outconfbase)/$$i . ; done
	cd $(tree-lib-prefix) && \
		ln -s ../../../../python/$(outconfbase) python
	cd $(tree-share-prefix) && \
		ln -s $(top-src-dir)/ly ly && \
		ln -s ../../../../mf mf && \
		ln -s $(top-src-dir)/ps && \
		ln -s ../../../../python/$(outconfbase) python && \
		ln -s $(top-src-dir)/scm && \
		ln -s $(top-src-dir)/scripts scripts
	cd $(tree-share-prefix)/dvips && \
		ln -s ./../../../mf/$(outconfbase) mf-out && \
		ln -s $(top-src-dir)/ps
	cd $(tree-share-prefix)/tex && \
		ln -s $(top-src-dir)/tex source && \
		ln -s ../../../../../tex/$(outconfbase) tex-out && \
		ln -s ../../../../../mf/$(outconfbase) mf-out

	cd $(tree-share-prefix)/fonts && \
		ln -s $(top-src-dir)/mf source && \
		true
	-cd $(tree-share-prefix)/elisp && \
		ln -sf ../../../../../../elisp/$(outconfbase)/lilypond-words.el . && \
		ln -s $(top-src-dir)/elisp/*.el .
	$(foreach i,$(CATALOGS), \
		(mkdir -p $(tree-share)/locale/$i/LC_MESSAGES && \
		cd $(tree-share)/locale/$i/LC_MESSAGES && \
		ln -sf ../../../../../po/$(outconfbase)/$i.mo lilypond.mo) &&) true
	touch $(tree-share-prefix)/lilypond-force

$(tree-share-prefix)/mf-link-tree link-mf-tree: $(tree-share-prefix)/lilypond-force
	-rm -f $(tree-share-prefix)/fonts/otf/* &&  \
	rm -f $(tree-share-prefix)/fonts/svg/* &&  \
	rm -f $(tree-share-prefix)/fonts/tfm/* &&  \
	rm -f $(tree-share-prefix)/fonts/type1/* &&  \
		cd $(tree-share-prefix)/fonts/otf && \
		ln -s ../../../../../../mf/$(outconfbase)/*.otf .
	-cd $(tree-share-prefix)/fonts/svg && \
		ln -s ../../../../../../mf/$(outconfbase)/*.svg .
	-cd $(tree-share-prefix)/fonts/tfm && \
		ln -s ../../../../../../mf/$(outconfbase)/*.tfm .
	-cd $(tree-share-prefix)/fonts/type1 && \
		ln -s ../../../../../../mf/$(outconfbase)/*.pfa .

TAGS.make: dummy
	etags -o $@ $(find $(srcdir) -name 'GNUmakefile*' -o -name '*.make')

local-clean: build-dir-setup-clean local-web-clean

local-web-clean:
	rm -rf $(outdir)/web-root/



build-dir-setup-clean:
	cd $(top-build-dir) && rm -rf share

$(config_h): config.hh.in
#
# this is to prevent people from getting
# undefined symbols  when we add them to config.h.in,
# and they blindly run "cvs update; make".
#
	@echo
	@echo ' *** $(config_h) is out of date'
	@echo ' *** Remove it and rerun autogen:'
	@echo '         rm $(config_h); ./autogen.sh'
	@echo
	@false
