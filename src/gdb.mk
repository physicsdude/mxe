# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdb
$(PKG)_WEBSITE  := https://www.gnu.org/software/gdb/
$(PKG)_VERSION  := 7.12.1
$(PKG)_CHECKSUM := 4607680b973d3ec92c30ad029f1b7dbde3876869e6b3a117d8a7e90081113186
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc dlfcn-win32 expat libiconv readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-system-readline \
        host_configargs="LIBS=\"`$(TARGET)-pkg-config --libs dlfcn`\"" \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    # executables are always static and we don't the rest
     $(INSTALL) -m755 '$(1)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
     $(INSTALL) -m755 '$(1)/gdb/gdbserver/gdbserver.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
