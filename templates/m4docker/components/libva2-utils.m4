dnl BSD 3-Clause License
dnl
dnl Copyright (C) 2020, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

include(libva2.m4)

DECLARE(`LIBVA2_UTILS_VER',2.19.0)

ifelse(OS_NAME,ubuntu,`dnl
define(`LIBVA2_UTILS_BUILD_DEPS',`automake ca-certificates gcc g++ libdrm-dev libtool make pkg-config wget')
')

ifelse(OS_NAME,centos,`dnl
define(`LIBVA2_UTILS_BUILD_DEPS',`automake gcc gcc-c++ libdrm-devel libtool make pkg-config wget which')
')

define(`BUILD_LIBVA2_UTILS',`dnl
# build libva2-utils
ARG LIBVA2_UTILS_REPO=https://github.com/intel/libva-utils/archive/LIBVA2_UTILS_VER.tar.gz
RUN cd BUILD_HOME && wget -O - ${LIBVA2_UTILS_REPO} | tar xz
RUN cd BUILD_HOME/libva-utils-LIBVA2_UTILS_VER && \
  ./autogen.sh --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
')

REG(LIBVA2_UTILS)

include(end.m4)dnl
