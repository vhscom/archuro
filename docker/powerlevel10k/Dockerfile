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
RUN groupadd -r archuro && useradd --no-log-init -r -g archuro archuro
RUN bash -uexc 'pacman -Sy --noconfirm zsh git neofetch'

# Add p10k
FROM basebuilder AS p10kbuilder
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
RUN bash -uexc '\
    git clone https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && \
    echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc'

# Add Archuro
FROM p10kbuilder as archuro
EXPOSE 7005/tcp
VOLUME ["/root/powerlevel10k","/root/archuro"]
ENV LANG=en_US.utf8
ENV TERM=xterm-256color
USER archuro
WORKDIR /home/archuro
