# nylen/dotfiles

To install my dotfiles:

```sh
git clone git@github.com:nylen/dotfiles.git ~/dotfiles
~/dotfiles/_install.sh
```

On Linux, you're responsible for ensuring that `~/.bash_aliases` is loaded.
(On Debian systems this is probably happening from `~/.bashrc` by default.)

On OS X, this repo provides a `~/.bashrc` because there isn't one by default.
Among other things, it loads `~/.bash_aliases`.
