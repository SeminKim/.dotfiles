#==================================================#
### set default paths

export PATH=$HOME/bin:/usr/local/bin:/usr/local/cuda/bin:$PATH
export PATH=$HOME/anaconda3/bin:$PATH # anaconda3
export PATH=$HOME/.local/bin:$PATH
export MYVIMRC=$HOME/.vimrc
export SHELL=$(which zsh)
export ZSH=$HOME/.oh-my-zsh # oh-my-zsh
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export MYDOTFILES=$HOME/.dotfiles


#==================================================#
# terminal settings
export TERM='xterm-256color' # terminal color


#==================================================#
### zsh settings

export LS_COLORS=$(cat $MYDOTFILES/LS_COLORS)

# OH-MY-ZSH
# themes: https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="mrtazz_custom"   # set zsh theme

ZSH_THEME="spaceship"
SPACESHIP_USER_SHOW="always"
SPACESHIP_USER_COLOR="green"
SPACESHIP_DIR_COLOR="38"
SPACESHIP_GIT_SHOW="true"
SPACESHIP_GIT_BRANCH_COLOR="red"
SPACESHIP_GIT_STATUS_SHOW="false"
SPACESHIP_CHAR_SYMBOL='%{%G➜%} '
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  cuda          # CUDA status
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  char          # Prompt character
)
DISABLE_AUTO_UPDATE="true"  # no automatically update oh-my-zsh
HIST_STAMPS="mm/dd/yyyy"    # history with date stamps

# zsh plugins
plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  copypath
  copybuffer
  dirhistory
  history
  fzf
)

source $ZSH/oh-my-zsh.sh
setopt nosharehistory # do not share command line history across tmux windows/panes

# https://stackoverflow.com/questions/20512957/zsh-new-line-prompt-after-each-command
function precmd() {
    # Print a newline before the prompt, unless it's the
    # first prompt in the process.
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}


#==================================================#
### misc

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# personal aliases
for alias_file in "$HOME/.aliases"/*
do
    source $alias_file
done

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf preview
function fzfv()
{
    fzf --preview '[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (cat {}) 2> /dev/null | head -500'
}

# remove duplicates in PATH
export PATH="$(echo -n $PATH | awk -v RS=: -v ORS=: '!arr[$0]++')"
