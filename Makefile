PACKAGE=problemtools
CONF=support/checktestdata/config.mk
PROGRAMS=checktestdata default_validator interactive
LIBDIR=$(DESTDIR)/usr/lib/$(PACKAGE)/
ETCDIR=$(DESTDIR)/etc/kattis/problemtools

all: $(CONF)
	$(foreach prog,$(PROGRAMS),$(MAKE) -C support/$(prog);)

builddeb:
	dpkg-buildpackage -us -uc -tc -b

install: all
	python setup.py install --root $(DESTDIR)
	install -d $(LIBDIR)/bin
	$(foreach prog,$(PROGRAMS),install support/$(prog)/$(prog) $(LIBDIR)/bin;)
	install support/default_grader/default_grader $(LIBDIR)/bin
	cp support/viva/viva.jar $(LIBDIR)/bin
	install support/viva/viva.sh $(LIBDIR)/bin
	install -d $(ETCDIR)
	install etc/* $(ETCDIR)
	cp -r examples $(LIBDIR)/

$(CONF): support/checktestdata/bootstrap
	cd support/checktestdata && ./bootstrap

support/checktestdata/bootstrap:
	git submodule update --init

clean:
	$(foreach prog,$(PROGRAMS),$(MAKE) -C support/$(prog) clean;)
	python setup.py clean --all
	rm -rf dist

distclean: clean
	rm -f $(CONF)
