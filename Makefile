# Specify defaults for testing
PREFIX := $(shell pwd)/prefix
PYTHON = dls-python
INSTALL_DIR = $(PREFIX)/lib/python2.7/site-packages
SCRIPT_DIR = $(PREFIX)/bin
MODULEVER=0.0

# Override with any release info
-include Makefile.private

# This is run when we type make
dist: setup.py $(wildcard */*.py) dls_edm/helper.pkl
	MODULEVER=$(MODULEVER) $(PYTHON) setup.py bdist_egg
	touch dist
	$(MAKE) -C documentation

# Need to make a pickle object of all the available edm objects on the system
# Check this in as libreadline is not installed on the build server...
dls_edm/helper.pkl: dls_edm/edmObject.py
	$(PYTHON) $<

# Clean the module
clean:
	$(PYTHON) setup.py clean
	-rm -rf build dist *egg-info installed.files
	# Don't remove helper.pkl for now since we can't build it yet.
	#-rm -rf dls_edm/helper.pkl
	-find -name '*.pyc' -exec rm {} \;
	$(MAKE) -C documentation clean	

# Install the built egg
install: dist
	$(PYTHON) setup.py easy_install -m \
		--record=installed.files \
		--install-dir=$(INSTALL_DIR) \
		--script-dir=$(SCRIPT_DIR) dist/*.egg
		
