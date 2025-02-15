#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
#	newlib.sh
#
#		m68k-elfx toolchain の newlib ビルド
#		(事前に download.sh でファイルをダウンロードしておく必要がある)
#
#------------------------------------------------------------------------------
#
#	Copyright (C) 2022 Yosshin(@yosshin4004)
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

# 共通設定を読み込み

. scripts/common.sh

export PATH=${INSTALL_DIR}/bin:${PATH}

# ディレクトリ作成
mkdir -p ${INSTALL_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${SRC_DIR}

#-----------------------------------------------------------------------------
# newlib のビルド
#-----------------------------------------------------------------------------

cd ${DOWNLOAD_DIR}
mkdir -p ${BUILD_DIR}/${NEWLIB_DIR}
tar zxvf ${NEWLIB_ARCHIVE} -C ${SRC_DIR}

export CC_FOR_TARGET=${PROGRAM_PREFIX}gcc
export LD_FOR_TARGET=${PROGRAM_PREFIX}ld
export AS_FOR_TARGET=${PROGRAM_PREFIX}as
export AR_FOR_TARGET=${PROGRAM_PREFIX}ar
export RANLIB_FOR_TARGET=${PROGRAM_PREFIX}ranlib
#
#	次の記述は、
#		if [ ! -v newlib_cflags ]; then
#	としたいが、-v が使えない bash 環境が存在するため、代替手段を利用する。
#	"${newlib_cflags+exists}" は、newlib_cflags が未定義なら空文字（偽）、
#	そうでなければ exists（真）になる。従って -v の代替になる。
#
if [ ! "${newlib_cflags+exists}" ]; then
	newlib_cflags=""
fi
export newlib_cflags="${newlib_cflags} -DPREFER_SIZE_OVER_SPEED -D__OPTIMIZE_SIZE__"

cd ${BUILD_DIR}/${NEWLIB_DIR}
${SRC_DIR}/${NEWLIB_DIR}/configure \
    --prefix=${INSTALL_DIR} \
    --target=${TARGET} \

make -j${NUM_PROC} 2<&1 | tee build.newlib.1.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then
	exit 1;
fi
make install | tee build.newlib.2.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then
	exit 1;
fi

cd ${ROOT_DIR}

#------------------------------------------------------------------------------
# 正常終了
#------------------------------------------------------------------------------

echo ""
echo "-----------------------------------------------------------------------------"
echo "The newlib building process is completed successfully."
echo "-----------------------------------------------------------------------------"
echo ""
exit 0
