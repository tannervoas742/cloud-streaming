dnl BSD 3-Clause License
dnl
dnl Copyright (C) 2021, Intel Corporation
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

DECLARE(`LIBVPL_VER',2023.3.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`LIBVPL_BUILD_DEPS',`automake ca-certificates gcc g++ make pkg-config wget cmake dh-autoreconf')'
`define(`LIBVPL_INSTALL_DEPS',`')'
)

define(`BUILD_LIBVPL',
ARG LIBVPL_REPO=https://github.com/intel/libvpl/archive/v`'LIBVPL_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${LIBVPL_REPO} | tar xz
ifdef(`LIBVPL_PATCH_PATH',`PATCH(BUILD_HOME/libvpl-LIBVPL_VER,LIBVPL_PATCH_PATH)')dnl
# build libvpl
RUN cd BUILD_HOME/libvpl-LIBVPL_VER && \
    mkdir build && cd build && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR \
      .. && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
)

define(`ENV_VARS_LIBVPL',`dnl
# While onevpl was renamed to libvpl, as of now this mostly concerns project
# naming and repository location. Environment variable we define below still
# follows onevpl naming convention.
ENV ONEVPL_SEARCH_PATH=BUILD_LIBDIR/
')

REG(LIBVPL)

include(end.m4)dnl
