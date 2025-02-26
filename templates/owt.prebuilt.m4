dnl BSD 3-Clause License
dnl
dnl Copyright (C) 2020-2023, Intel Corporation
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

define(`OWT_GS_BIN_BUILD_DEPS',xz-utils)
define(`OWT_GS_BIN_INSTALL_DEPS',)

define(`BUILD_OWT_GS_BIN',`dnl
# We use OWT prebuilt binaries here to save on time and resources required to
# build OWT from sources. OWT built is disk space and time consuming process since
# sources weigh ~9GB. So, while its quite possible to build OWT from sources and
# we provide such a process in dedicated dockerfile, its more convenient to
# use a prebuilt OWT to build dependent projects.
COPY prebuilt/linux-x86_64 BUILD_HOME/linux-x86_64
RUN cp -rd BUILD_HOME/linux-x86_64/* BUILD_DESTDIR && \
    cp -rd BUILD_HOME/linux-x86_64/* /

')

REG(OWT_GS_BIN)

include(end.m4)
