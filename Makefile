#------------------------------------------------------------------------------
#
#	Makefile for elf2x68k
#
#	Copyright (C) 2023 Yuichi Nakamura (@yunkya2)
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	    http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#
#------------------------------------------------------------------------------

help:
	@echo "make all        - Build m68k-xelf development environment"
	@echo "make m68k-xelf  - Build m68k cross toolchain only"
	@echo "make download   - Download prerequisite archives only"
	@echo "make install    - Install X68k support files only"
	@echo "make uninstall  - Uninstall X68k support files"
	@echo "make clean      - Remove artifacts"
	@echo "make pristine   - Remove artifacts including downloaded archives"
	@echo "make help       - Show this message"

all: m68k-xelf install

m68k-xelf: binutils gcc-stage1 newlib gcc-stage2

binutils: download
	scripts/binutils.sh

gcc-stage1: download
	scripts/gcc-stage1.sh

newlib: download
	scripts/newlib.sh

gcc-stage2: download
	scripts/gcc-stage2.sh

download:
	scripts/download.sh

install:
	scripts/install.sh

uninstall:
	scripts/uninstall.sh

clean:
	-rm -rf build_gcc
	-rm -rf m68k-xelf
	$(MAKE) clean -C src/libx68k

pristine: clean
	-rm -rf download

ARCHIVE="elf2x68k-`uname -s|sed 's/_.*//'`-`date +%Y%m%d`"
release:
	tar jcvf ${ARCHIVE}.tar.bz2 m68k-xelf --owner=root --group=root

.PHONY:	all clean pristine help
.PHONY:	download toolchain binutils gcc-stage1 newlib gcc-stage2
.PHONY:	install uninstall release
