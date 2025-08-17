# 環境変数
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad
export CLICOLOR=1

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
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

# 補完設定
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt list_packed
zstyle ':completion:*' list-colors ''

# その他設定
setopt correct
setopt no_beep

# Git情報表示設定
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# Git現在のbranch名を表示（*付きで）
parse_git_branch() {
    BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$BRANCH" ]; then
        # 変更があるかチェック
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null || [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            echo " (* $BRANCH)"
        else
            echo " ($BRANCH)"
        fi
    fi
}

# プロンプト設定（統合版）
precmd() {
    vcs_info
    PROMPT='%* %F{cyan}%~%f%F{yellow}$(parse_git_branch) %F{magenta}$ %f'
}
RPROMPT='${vcs_info_msg_0_}'

# エイリアス
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

# プラグインを有効化（OS別対応を維持）
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS（Homebrew）環境
    if command -v brew >/dev/null 2>&1; then
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
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

# Dev Container環境での履歴永続化
if [ -n "$REMOTE_CONTAINERS" ] && [ -d ~/.zsh ]; then
    export HISTFILE=~/.zsh/history
fi