# Copyright 2010-2013 Intel Corporation.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, version 2.1.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# Disclaimer: The codes contained in these modules may be specific
# to the Intel Software Development Platform codenamed Knights Ferry,
# and the Intel product codenamed Knights Corner, and are not backward
# compatible with other Intel products. Additionally, Intel will NOT
# support the codes or instruction set in future products.
#
# Intel offers no warranty of any kind regarding the code. This code is
# licensed on an "AS IS" basis and Intel is not obligated to provide
# any support, assistance, installation, training, or other services
# of any kind. Intel is also not obligated to provide any updates,
# enhancements or extensions. Intel specifically disclaims any warranty
# of merchantability, non-infringement, fitness for any particular
# purpose, and any other warranty.
#
# Further, Intel disclaims all liability of any kind, including but
# not limited to liability for infringement of any proprietary rights,
# relating to the use of the code, even if Intel is notified of the
# possibility of such liability. Except as expressly stated in an Intel
# license agreement provided with this code and agreed upon with Intel,
# no license, express or implied, by estoppel or otherwise, to any
# intellectual property rights is granted herein.

REPOROOTDIR = $(CURDIR)
include mk/definitions.mk

ifneq ($(WINTEST), 1)
include mpss-metadata.mk
endif

BIN_DIR := bin
MAIN_EXEC := $(BIN_DIR)/miccheck.py
MOD_DIR := _miccheck
MPSS_FLASH_VERSION ?= '0'
DESTDIR_SRC := $(DESTDIR)$(srcdir)/miccheck
DESTDIR_MOD := $(DESTDIR_SRC)/$(MOD_DIR)

all: version

version: $(MPSS_METADATA_C)
	echo '__version__ = "$(MPSS_VERSION)"' > _miccheck/common/version.py
	echo '__flash_version__ = "$(MPSS_FLASH_VERSION)"' >> _miccheck/common/version.py
	echo '__smc_fw_version__ = "$(SMC_FW_VERSION)"' >> _miccheck/common/version.py
	echo '__smc_bootloader_version__ = "$(SMC_BL_VERSION)"' >> _miccheck/common/version.py

# 'compilation' stage of python program
pyinstall: version
	python2.7 $(PYINSTALL) -F $(MAIN_EXEC)

install-pyinstall: $(DESTDIR)$(bindir)
	$(INSTALL) dist/miccheck $(DESTDIR)$(bindir)

install: install-modules install-main

install-modules: $(MOD_DIR) $(DESTDIR_SRC)
	$(CP) -r $(MOD_DIR) $(DESTDIR_MOD)

install-main: $(MAIN_EXEC) $(DESTDIR)$(bindir)
	$(INSTALL) $(MAIN_EXEC) $(DESTDIR)$(bindir)

install-modules-win: $(MOD_DIR) $(DESTDIR)$(bindir)
	$(CP) -r $(MOD_DIR) $(DESTDIR)$(bindir)

$(DESTDIR_SRC): $(DESTDIR)$(srcdir)
	$(INSTALL_d) $@

$(DESTDIR_MOD): $(DESTDIR_SRC)
	$(INSTALL_d) $@

clean:
	- $(RM) build -rf
	- $(RM) dist -rf

uninstall:

.PHONY: all install uninstall install-modules install-main version

include mk/destdir.mk
