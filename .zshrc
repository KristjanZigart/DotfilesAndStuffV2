HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Install plugin manager and plugins
source $HOME/.zsh/antigen/antigen.zsh
antigen bundle mafredri/zsh-async
antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle hcgraf/zsh-sudo
antigen bundle zsh-users/zsh-syntax-highlighting # Needs to be last bundle
antigen apply

# Setup pure prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

setopt histignoredups # Ignore command history duplicates
setopt menu_complete # Tab completion when choice ambiguous

# I want default edior to be nvim, but bindings should be emacs like
export EDITOR="nvim"
bindkey -e

### aliases
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias ll='ls -aFlh --color=auto --group-directories-first'
alias ls='ls -h --color=auto --group-directories-first'
alias ml='minicom'
alias cl='rm -fr build'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

### Various exports
#export GO111MODULE=on

# Zephyr env var
export ZEPHYR_BASE="$HOME/Programs/ncs/zephyr"
export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
export GNUARMEMB_TOOLCHAIN_PATH="$HOME/miniconda3"
export INVOKE_PATHS_NRF5_SDK="$HOME/Work/nrf5_sdk"

# Various other paths
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/Programs
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/bin

### Various shell functions
# Fixes the issue where pressing delete key would print tilda character
bindkey  "^[[3~"  delete-char

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

# Quick add, commit, push shortcut
function gitup() {
    git add .
    git commit -a -m "$1"
    git push
}

# Nice grep function, searches for a string recursively
function grp {
    grep -rnIi "$1" . --color;
}

# Nice find function for file names
function fnd {
    find . -name "$1";
}

# Open the Pull Request URL for your current directory's branch
# (base branch defaults to dev)
function openpr() {
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/dev..."$branch_name
  xdg-open $pr_url;
}

# Run git push and then immediately open the Pull Request URL
function gpr() {
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  git push --set-upstream origin $branch_name

  if [ $? -eq 0 ]; then
    openpr
  else
    echo 'failed to push commits and open a pull request.';
  fi
}

# For GCC color output
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

