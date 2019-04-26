PROG=daedalus-project-docker-build

prefix = /usr/local
bindir = $(prefix)/bin
sharedir = $(prefix)/share
mandir = $(sharedir)/man
man1dir = $(mandir)/man1

TEST_DIR=$(PWD)/tests

all: build

test:
	@echo "executing $(PROG) unit tests"
	@echo "- debug"
	( $(TEST_DIR)/01-test_debug.sh )
	@echo "- variables"
	( $(TEST_DIR)/02-test_variables.sh )

cover:
	./get_coverage tests


build:
	( cp -R lib clean_lib )

clean:
	( rm -f $(PROG) )

install:
	install $(PROG) $(DESTDIR)$(bindir)

uninstall:
	( rm $(DESTDIR)$(bindir)$(PROG) )
