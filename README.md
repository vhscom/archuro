# Archuro

> Your development workflow, hypervized.

![archuro](./screenshots/photo_2019-10-21_16.33.22-fs8.png)

Archuro is a CLI written in Bash designed to streamline set-up and management of a Mac for cross-platform, containerized app development.

## Features

Archuro replaces the "my dotfiles" concept with something far more powerful for modern development workflows.

- Normalizes macOS with Arch by installing Bash 5 (and patches).
- Manage all tasks from the minimalist, cross-platform `archuro` CLI.
- Create [Extended Builds](#extended-builds) of Arch suited for your workflow
- Hotkey access to `archuro tty` command via `Ctrl+p` using Bash 5
- 2 terminals: [Kitty](https://github.com/kovidgoyal/kitty) (cross-platform), [HyperTerm](https://hyper.is) (via Homebrew)
- Opinionated Brew manifest with customizable dependencies
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for Zsh shells with optional shared config
- Creates a custom profile named Archuro for Mac's Terminal app
- SCM-friendly dotfile management using GNU Stow
- Vivialdi web browser for productivity and development
- Automates VSCode setup and helps keep track of extensions

## Screens and demo

<p>
  <img src="./archuro/raw/branch/master/screenshots/hyper-split-cli-fs8.png" title="Archuro Hyper Split CLI" width="48%" alt="cli">
  <img src="./archuro/raw/branch/master/screenshots/hyper-split-neofetch-fs8.png" width="48%" title="Archuro Hyper Split Neofetch" alt="neofetch">
</p>

Videos? Several in the [`screenshots`](./screenshots) directory.

## Installation

Assumes basic knowledge of command line, git and file system management.

1. Copy repository source code.
2. Run `make install` to move `bin/archuro` to `/usr/local/bin`.
3. Run `archuro init` to install build essentials. Add `-S` to proceed with GNU Stow.
4. Finally, run `archuro install` to install dependencies.

Repeat steps 2-3 on an [Extended Build](#extended-builds) of Arch Linux to share your dotfiles.

To uninstall run `make uninstall` from project root.

## Usage

Run `archuro --help` after installation for usage instructions. To get a disposabe Arch Linux container run `archuro tty`. To get a reusable container run `archuro save && archuro run`. Run `archuro ps` to view running containers and `archuro attach` to attach a tty otherwise.

Once dotfiles are stowed with `archuro init -S` a simple `archuro update` will update configured applications.

## Homebrew

Archuro assumes all macOS development dependencies are managed using a manifest file known as a `Brewfile`. The Brewfile keeps track dependencies and may also influence Homebrew how to tweak app installations specific for an environment. The manifest lives in `stow/dot-Homebrew` file which becomes symlinked to `~/.Brewfile` for use by the current user during `archuro init` using the `-S` flag.

## VSCode

Settings and extensions are kept in the `stow/dot-vscode` directory under the project root:

```
└── stow
    ├── dot-profile
    ├── dot-vscode
    │   ├── extensions
    │   └── settings.json
```

The `stow/dot-profile` file contains scripts to manage them:

- `cx` lists currently installed VSCode extensions
- `cxinstall` attempts to install saved extensions from `~/.vscode/extensions`
- `cxsave` appends currently installed VSCode extensions to `~/.vscode/extensions`
- `cxremoveall` removes all currently installed extensions (use with caution)

Platform-specific [setting locations](https://vscode.readthedocs.io/en/latest/getstarted/settings/#settings-file-locations) vary. Mac and Windows store VSCode settings along with application data and not in the user's home directory. Keep this in mind and create a symbolic link (`ln -s`) to the user `$HOME` or adjust scripts as needed.

For more info on extensions see [User and Workspace settings](https://vscode.readthedocs.io/en/latest/getstarted/settings/) on the VSCode docs site.

## Extended builds

Spinning up a disposable Arch Linux tty is great. But throwing away work during repetitive tasks isn't. For this reason Archuro provides a method for persisting state and heavily caching development dependencies on Arch Linux using Docker.

Run `archuro save` to build and tag an `extended` Arch Linux image. Think of it as your own custom build of the OS and update the `Dockerfile` provided to customize as desired. Rerun `archuro save` anytime to build and tag a new docker image (or use `docker` cli directly).

View tagged Arch Linux builds by running `archuro ls`.

### Sharing dotfiles

Share dotfiles between systems. To do so use docker to create a [shared file system](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) after building the `Dockerfile`. Specific steps described in more detail here:

1. Start with `docker build .` to build the Archuro `Dockerfile` image.
2. Tag image with `docker tag $(docker images -q | head -1) archlinux/extended:lastest`.
3. Confirm image available with `archuro ls` which looks for `archlinux` tagged images.

Then create a bind mount while starting an interactive tty with `zsh` as the shell:

```sh
docker run -it -v ~/archuro/stow:/root/archuro/stow archlinux/extended bash
```

At a `bash` prompt run `archuro init --stow` to install and symlink dotfiles. Then run `zsh` to access the Z shell and begin the configuration wizard of Powerlevel10k. If you don't see the configuration wizard it's likely because `~/.p10k.zsh` exists and was already sourced.

## Exposting ports

Declaring a `PORT` in a `Dockerfile` isn't enough. When running the `Dockerfile` pass the `-p` flag like `-p 8181:8080/tcp` to bind host port `8181` to `8080` of the guest.

## Package management

Installed on demand. Modify `/stow/dot-Brewfile` after running `archuro init` to adjust. Then run `archuro install` to install and `archuro update` to check for new versions and update automatically.

## Troubleshooting

Must a mess of stuff I dumped in here during initial development.

> RUNNING OUT OF HDD SPACE

❯ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
deleted: sha256:6c8e85e79ab8dafdfa3664574ea3a201d7e8ed8b91d039f77e32fb58ba5bc469
deleted: sha256:13b7fc8a1bc12abf3913f1d4ad1927cf534f161a4b6708c9b3d9912e95788150

Total reclaimed space: 0B

see also high tea readme

> GIT BASH COMPLETIONS AREN'T WORKING. WHAT GIVES?

You fail at life. Just kidding. You're probably on a Mac, bro.

> CUSTOM PACKAGE X ISN'T WORKING AS EXPECTED

When `brew` first installs a package and that package requires some configuration Brew will output setup instructions in a section called _Caveats_. To see the caveats again simply run `brew info <package>`.

> SOMETIMES THERE CAN BE CONFLICTS from cross-platform and Homebrew...

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

> SOMETIMES THERE'S AN APP FOR THAT ALREADY WHICH WAS MANUALLY INSTALLED

==> Satisfying dependencies
==> Downloading https://spectacle.s3.amazonaws.com/downloads/Spectacle+1.2.zip
Already downloaded: /Users/jos/Library/Caches/Homebrew/downloads/b121fce845422e8d6002e6968285593312527586ff85399b56362b64b1c4e107--Spectacle 1.2.zip
==> Verifying SHA-256 checksum for Cask 'spectacle'.
==> Installing Cask spectacle
Error: It seems there is already an App at '/Applications/Spectacle.app'.
==> Purging files for version 1.2 of Cask spectacle
Installing spectacle has failed!
Homebrew Bundle failed! 1 Brewfile dependency failed to install.


> SOMETIMES MAS ITEMS IN BREWFILE GIVES YA SOME ISSUES. MAYBE LOGIN FIRST?

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
