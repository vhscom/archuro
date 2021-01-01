# Docker version 19.03.2, build 6a30dfc

#
# Copyright (C) 2019  VHS <0xc000007b@tutanota.com>
#
# This file is part of Archuro.
#
# Archuro is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Archuro is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Arch base
FROM archlinux/base AS basebuilder
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
RUN bash -uexc 'pacman -Sy --noconfirm sudo man openssh'

# HACK: Remove following 3 lines with sudo 1.9 in archlinux/base
# to resolve the following issue running sudo:
#
#   sudo: setrlimit(RLIMIT_CORE): Operation not permitted
#
# @see https://unix.stackexchange.com/a/578950
# RUN bash -uexc 'touch /etc/sudo.conf'
# RUN bash -uexc 'echo "Set disable_coredump false" >> /etc/sudo.conf'
# RUN bash -uexc 'pacman -Sy --noconfirm libffi'

# Add Powerlevel10k for zsh
FROM basebuilder AS p10kbuilder
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
RUN bash -uexc 'pacman -Sy --noconfirm git'
RUN bash -uexc 'git clone https://github.com/romkatv/powerlevel10k.git /usr/local/etc/powerlevel10k'

# Add Archuro
FROM p10kbuilder as archurobuilder
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
ARG USER=archuro
RUN bash -uexc 'pacman -Sy --noconfirm make zsh'
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dont-prompt-$USER-for-password
RUN useradd -Ng wheel -s /bin/zsh --create-home --no-log-init $USER
WORKDIR /home/$USER/archuro
COPY . .
RUN ["make","install"]
RUN rm ../.bashrc && rm ../.bash_profile && rm ../.bash_logout
RUN ["archuro","init","-S"]

# Login as Archuro user
FROM archurobuilder
ARG USER=archuro
EXPOSE 8080/tcp
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
RUN bash -uexc 'pacman -Sy --noconfirm neofetch'
VOLUME ["/home/$USER/archuro"]
USER $USER
