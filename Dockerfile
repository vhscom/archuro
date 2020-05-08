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
RUN bash -uexc 'pacman -Sy --noconfirm make zsh which'
RUN bash -uexc 'chsh -s $(which zsh)'
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dont-prompt-$USER-for-password
RUN useradd -Ng wheel -s /bin/zsh --create-home --no-log-init archuro
WORKDIR /home/$USER/archuro
COPY . .
RUN ["make","install"]
RUN rm ../.bashrc && rm ../.bash_profile && rm ../.bash_logout
RUN ["archuro","init","-S"]

# Final
FROM archurobuilder
ARG USER=archuro
EXPOSE 8080/tcp
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
RUN bash -uexc 'pacman -Sy --noconfirm neofetch'
VOLUME ["/home/archuro/archuro"]
USER $USER
