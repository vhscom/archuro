# Archuro

> Your development workflow, hypervized.

![archuro](./screenshots/photo_2019-10-21_16.33.22-fs8.png)

Archuro is a CLI designed to streamline set-up and management of a Mac for cross-platform, containerized app development using Arch Linux.

## Features

- Quickly install all tools necessary to run Arch Linux on macOS.
- Installs [GNU Stow](https://www.gnu.org/software/stow/) for robust dotfile management.
- Appealing prompt with [Powerlevel10k](https://github.com/romkatv/powerlevel10k) and [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack) for Zsh.
- Maximize reuse of user config between macOS and Arch Linux.
- Bash and Zsh productivity affordances [without getting clever](https://github.com/zsh-users/antigen).
- Install Bash 5 from source on macOS to normalize it with Arch Linux.
- Create [Extended Builds](#extended-builds) of Arch suited for your workflow.
- Hotkey access to `archuro tty` command via `Ctrl+p` using Bash 5.
- Opinionated Brew manifest with customizable dependencies.
- Create a custom profile named Archuro for Mac's Terminal app.
- Install Vivialdi web browser for productivity and development.
- Automate [VS Code](https://code.visualstudio.com/) setup and [helps keep track](#vs-code) of extensions.
- Recommended terminal apps: [Kitty](https://github.com/kovidgoyal/kitty) and [Hyper](https://hyper.is) with [Verminal](https://github.com/defringe/verminal).

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

### Homebrew

Archuro assumes all macOS development dependencies are managed using a manifest file known as a `Brewfile`. The Brewfile keeps track dependencies and may also influence Homebrew how to tweak app installations specific for an environment. The manifest lives in `stow/dot-Homebrew` file which becomes symlinked to `~/.Brewfile` for use by the current user during `archuro init` using the `-S` flag.

### VS Code

Settings and extensions are kept in the `stow/dot-vscode` directory under the project root:

```
└── stow
    ├── dot-profile
    ├── dot-vscode
    │   ├── extensions
    │   └── settings.json
```

The `stow/dot-profile` file contains scripts to manage them:

- `cx` lists currently installed VS Code extensions
- `cxinstall` attempts to install saved extensions from `~/.vscode/extensions`
- `cxsave` appends currently installed VS Code extensions to `~/.vscode/extensions`
- `cxremoveall` removes all currently installed extensions (use with caution)

Platform-specific [setting locations](https://vscode.readthedocs.io/en/latest/getstarted/settings/#settings-file-locations) vary. Mac and Windows store VS Code settings along with application data and not in the user's home directory. Keep this in mind and create a symbolic link (`ln -s`) to the user `$HOME` or adjust scripts as needed.

For more info on extensions see [User and Workspace settings](https://vscode.readthedocs.io/en/latest/getstarted/settings/) on the VS Code docs site.

### Extended builds

Spinning up a disposable Arch Linux tty is great. But throwing away work doing repetitive tasks isn't. For this reason Archuro provides extended builds for persisting state and heavily caching development dependencies under Arch Linux using Docker. Think of it as your own custom build of the OS and update the `Dockerfile` provided to customize as desired. 

Run `archuro save` to automatically create and tag an `archlinux/extended` build as shown here:

```
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
archlinux/extended   latest              0104776b36cc        2 seconds ago       616MB
archlinux/base       latest              5323a8f7a7a4        3 weeks ago         461MB
```

Rerun `archuro save` to rebuild the `Dockerfile` and update the `IMAGE ID` associated with the extended build.

#### Sharing dotfiles

To share dotfiles with your extended build container run `archuro save` to build the Dockerfile image and then run `archuro run` to create a [shared file system](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) using a bind mount, i.e.

```sh
docker run -it -v ~/archuro/stow:/root/archuro/stow archlinux/extended bash
```

Once the Arch tty starts run `archuro init --stow` to install GNU Stow and symlink your dotfiles. Then run `zsh` to access the Z shell and start using your dotfiles right away.

#### Exposing ports

Run `archuro run` to expose port `8080` defined in the `Dockerfile` with `8080` on the host. If you need more customization use `docker run` directly as shown here in combination with the bind mount created to [share dotfiles](#sharing-dotfiles):

```sh
docker run -it -p 8080:8080 -v ~/archuro/stow:/root/archuro/stow archlinux/extended:latest bash
```

### Package management

If you're backing up an existing system:

1. Run `brew bundle dump` to write all installed casks/formulae/taps into a Brewfile for you.
2. Copy that into Archuro's `stow/dot-Brewfile`.
3. Run `archuro init` to install [GNU Stow](https://www.gnu.org/software/stow/) and Bash 5.
4. Safely create symlinks to your `$HOME` directory using GNU Stow with `archuro init --stow`.

Otherwise:

Modify `stow/dot-Brewfile` to adjust macOS dependencies. If you're not using Homebrew yet `archuro init` will install it alongside GNU Stow automatically. Then run `archuro install` or `archuro update` to check for new dependencies and install them automatically.

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
