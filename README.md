# Archuro

Portable Arch Linux development workflow and dotfile managment.

## Features

- Cross-platform shell shell envrionment abstraction
- Simple CLI for managing Arch Linux on macOS Catalina
- SCM-friendly [dotfile] management using GNU Stow
- Bash 5 with patches and programmable command completions
- Opinionated Brew manifest with customizable dependencies
- Vivialdi web browser for productivity and development
- Themed Kitty and Hyper terminals
- Customized macOS Terminal profile based on Pro
- Hotkey access to archlinux tty from within Bash using `Ctrl+p`

## Roadmap

- Touchbar buttons for man (and tldr) similar to Terminal
- Linux Brew <https://docs.brew.sh/Homebrew-on-Linux> for portable dependency manifest
- Ranger

## Packages

Installed on demand. Modify `/stow/dot-Brewfile` after running `archuro init` to adjust. Then run `archuro install` to install and `archuro update` to check for new versions and update automatically.

- Nerd Fonts (everywhere) <https://github.com/ryanoasis/nerd-fonts>
- Neovim <https://neovim.io>
- gruvbox <https://github.com/morhetz/gruvbox>?
- ...

## Usage

Once you've stowed you can use `brew bundle` just like you normally would. The thing to keep in mind is that some dependencies are built from source and therefore are not designed to be managed by Homebrew. Homebrew will error on these things. And that may be OK if the intention is not to replace exiting binaries as they may be shared between mountpoints across systems. 

## Troubleshooting

RUNNING OUT OF HDD SPACE

❯ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
deleted: sha256:6c8e85e79ab8dafdfa3664574ea3a201d7e8ed8b91d039f77e32fb58ba5bc469
deleted: sha256:13b7fc8a1bc12abf3913f1d4ad1927cf534f161a4b6708c9b3d9912e95788150

Total reclaimed space: 0B

see also high tea readme

GIT BASH COMPLETIONS AREN'T WORKING. WHAT GIVES?

You fail at life. Just kidding. You're probably on a Mac, bro.

CUSTOM PACKAGE X ISN'T WORKING AS EXPECTED

When `brew` first installs a package and that package requires some configuration Brew will output setup instructions in a section called _Caveats_. To see the caveats again simply run `brew info <package>`.

SOMETIMES THERE CAN BE CONFLICTS from cross-platform and Homebrew...

Error: Could not symlink bin/ffmpeg
Target /usr/local/bin/ffmpeg
already exists. You may want to remove it:
  rm '/usr/local/bin/ffmpeg'

To force the link and overwrite all conflicting files:
  brew link --overwrite ffmpeg

To list all files that would be deleted:
  brew link --overwrite --dry-run ffmpeg
Linking /usr/local/Cellar/ffmpeg/4.2.1_1... 
Using ffmpeg


SOMETIMES THERE'S AN APP FOR THAT ALREADY WHICH WAS MANUALLY INSTALLED

==> Satisfying dependencies
==> Downloading https://spectacle.s3.amazonaws.com/downloads/Spectacle+1.2.zip
Already downloaded: /Users/jos/Library/Caches/Homebrew/downloads/b121fce845422e8d6002e6968285593312527586ff85399b56362b64b1c4e107--Spectacle 1.2.zip
==> Verifying SHA-256 checksum for Cask 'spectacle'.
==> Installing Cask spectacle
Error: It seems there is already an App at '/Applications/Spectacle.app'.
==> Purging files for version 1.2 of Cask spectacle
Installing spectacle has failed!
Homebrew Bundle failed! 1 Brewfile dependency failed to install.


SOMETIMES MAS ITEMS IN BREWFILE GIVES YA SOME ISSUES. MAYBE LOGIN FIRST?

Using neovim
Installing openssl
Using pngquant
Using python
Installing sip
Using socat
Installing tcpdump
Using tree
Using yamllint
Using yarn
Using wget
Installing vivaldi
Using com.apple.dt.xcode
No downloads
Warning: No downloads began
Installing bitwarden has failed!
Using wireguard
Installing youtube-dl
==> Satisfying dependencies
==> Downloading https://spectacle.s3.amazonaws.com/downloads/Spectacle+1.2.zip
==> Verifying SHA-256 checksum for Cask 'spectacle'.
==> Installing Cask spectacle
Error: It seems there is already an App at '/Applications/Spectacle.app'.
==> Purging files for version 1.2 of Cask spectacle
Installing spectacle has failed!
No downloads
Warning: No downloads began
Installing amphetamine has failed!

[dotfile]: https://dotfiles.github.io "GitHub does dotfiles"
