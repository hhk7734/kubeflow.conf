ZSH_DISABLE_COMPFIX="true"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle '"':omz:update'"' mode auto
zstyle '"':omz:update'"' frequency 13 # in days

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  aws
  fzf
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

is_installed() {
  [ -n "$(command -v "$1" 2>/dev/null)" ]
}

# User configuration

export PATH=$PATH:$HOME/.local/bin

. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --follow' # --hidden --exclude .git
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if is_installed kubectl; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

autoload -Uz compinit && compinit
