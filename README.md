# nylen/dotfiles

To install my dotfiles:

```sh
git clone https://github.com/nylen/dotfiles.git ~/dotfiles
~/dotfiles/_install.sh
```

On Linux, you're responsible for ensuring that `~/.bash_aliases` is loaded.
(On Debian systems this is probably happening from `~/.bashrc` by default.)

On OS X, this repo provides a `~/.bashrc` because there isn't one by default.
Among other things, it loads `~/.bash_aliases`.

Place system-specific commands in a file called `~/.bashrc_local`.  (Or, on
Linux, you can also put them in `~/.bashrc`.)

### Tests

To run tests for some of the functionality included here, install the
[`bats`](https://github.com/nylen/bats-core#installing-bats-from-source)
testing framework, then do this:

```sh
bats ~/dotfiles/test/
```
