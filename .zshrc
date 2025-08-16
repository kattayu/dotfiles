# 環境変数
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
# 直前のコマンドの重複を削除
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 補完機能を有効にする
autoload -Uz compinit
compinit -u

# 補完パスの設定（OS別対応）
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS（ローカル）環境
    if [ -e /usr/local/share/zsh-completions ]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux（Dev Container）環境
    if [ -d /usr/share/zsh-completions ]; then
        fpath=(/usr/share/zsh-completions $fpath)
    fi
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%T %~ %F{magenta}$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

# git 現在のbranch名を表示
parse_git_branch() {
    BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$BRANCH" ]; then
        echo " ($BRANCH)"
    else
        echo ""
    fi
}

precmd() {
    PROMPT='%* %F{cyan}%~%f%F{yellow}$(parse_git_branch) %F{magenta}$ %f'
}

# プラグインを有効化（OS別対応）
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS（Homebrew）環境
    if command -v brew >/dev/null 2>&1; then
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux（Dev Container）環境
    if [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
    if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
fi