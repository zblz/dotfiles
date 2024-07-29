# Configuration files

Install [rcm](https://thoughtbot.github.io/rcm), and then checkout the
repository and link the files into place with:

```sh
git clone git@github.com:zblz/dotfiles.git $HOME/.dotfiles
env RCRC=$HOME/.dotfiles/host-$(hostname)/rcrc rcup -v
```
