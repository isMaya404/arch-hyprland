# zmodload zsh/zprof  # Load the profiling module
# ----------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Perf 
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1
export NVM_LAZY_LOAD=true NVM_AUTO_USE=false NVM_COMPLETION=false

# Set the dir we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k 
zinit ice depth=1;
zinit light romkatv/powerlevel10k

# Use "zinit ice wait lucid" to lazy load plugins & snippets 

# Add zsh snippets 

zinit ice wait lucid 
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::archlinux

# zinit ice wait lucid
# zinit snippet OMZP::command-not-found

# zinit ice wait lucid 
# zinit snippet OMZP::nvm

# Add zsh plugins 

# zinit ice wait lucid 
# zinit light lukechilds/zsh-nvm

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions

# Run this once in a blue moon 
# zinit update

# Load completions once then cache it for 24hrs 
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --------------------------------------------------------------------------

# Remove binding
bindkey -r '^L'

# --------------------------------------------------------------------------

# Keybindings

# tmux sessionizers 
bindkey -s '\el' "tms\n" 
bindkey -s '\ed' "tms switch\n" 
bindkey -s '\ef' 'tmux-sessionizer\n' 

# --------------------------------------------------------------------------

# Emacs Mode
# bindkey -e  

# Some useful emacs bindings for nav/editing: 

# M-b → move backward word
# M-f → move forward word
# M-d → del word after cursor

# "C-a: Move to BOL
# "C-e: Move to EOL
# "C-k: Delete from cursor to EOL
# "C-y: Paste the previously deleted text."

# Built in tty bindings:
# "C-w: Delete word beofre cursor 
# "C-u: Delete from cursor to BOL 

# --------------------------------------------------------------------------

# Vi Mode 
bindkey -v   

# Make word movements (w/W/e/E/b/B) consistent like vim
autoload -U select-word-style
select-word-style bash  

# Some qol functions for better vimming
move-to-middle-of-line() {
  local line=$BUFFER
  local len=${#line}
  CURSOR=$(( len / 2 ))
}

yank_to_clipboard() {
  zle vi-yank # yank normally
  print -rn -- "$CUTBUFFER" | wl-copy # yank also to clipboard (use xclip for x11)  
}

paste_from_clipboard_put_before() {
  local clip
  clip=$(wl-paste 2>/dev/null) || return 1
  LBUFFER+="$clip"
}

paste_from_clipboard_put_after() {
  local clip
  clip=$(wl-paste 2>/dev/null) || return 1
  # if not at end, move over one char
  (( CURSOR < ${#BUFFER} )) && zle vi-forward-char
  LBUFFER+="$clip"
}

# this is so good it's criminal
edit-command-line-nvim() {
  local tmpfile=$(mktemp /tmp/nvedit.XXXXXX)

  # Dump current buffer (what you typed so far) into tmpfile
  print -rn -- "$BUFFER" > "$tmpfile"

  # Open in nvim (blocking)
  nvim "$tmpfile"

  # Load back into ZLE buffer
  BUFFER=$(<"$tmpfile")
  CURSOR=${#BUFFER}

  rm -f "$tmpfile"
  zle reset-prompt
}

zle -N edit-command-line-nvim
zle -N paste_from_clipboard_put_before
zle -N paste_from_clipboard_put_after
zle -N move-to-middle-of-line
zle -N yank_to_clipboard

# Normal Mode:
bindkey -M vicmd n vi-backward-word        
bindkey -M vicmd N vi-backward-blank-word  

bindkey -M vicmd b vi-repeat-search        
bindkey -M vicmd B vi-rev-repeat-search    

bindkey -M vicmd 'j' backward-char
bindkey -M vicmd 'J' beginning-of-line

bindkey -M vicmd 'k' down-line-or-history

bindkey -M vicmd 'l' up-line-or-history
bindkey -M vicmd 'L' move-to-middle-line #  custom widget

bindkey -M vicmd 'p' forward-char
bindkey -M vicmd 'P' end-of-line

bindkey -M vicmd 'h' vi-put-after    
bindkey -M vicmd 'H' vi-put-before

#  custom widget 
bindkey -M vicmd '\eh' paste_from_clipboard_put_after
bindkey -M vicmd '\eH' paste_from_clipboard_put_before

bindkey -M vicmd 'o' yank_to_clipboard #  custom widget
bindkey -M vicmd 'O' vi-yank-whole-line     

bindkey -M vicmd 'm' vi-open-line-below
bindkey -M vicmd 'M' vi-open-line-above

bindkey -M vicmd 'y' set-mark-command
bindkey -M vicmd 'Y' vi-join

bindkey -M vicmd '\er' redo  # C-r is used by fzf so M-r instead

bindkey -M vicmd "gn" edit-command-line-nvim #  custom widget

# Visual Mode:
bindkey -M visual 'j' vi-backward-char
bindkey -M visual 'k' down-line
bindkey -M visual 'l' up-line
bindkey -M visual 'p' vi-forward-char

bindkey -M visual 'J' beginning-of-line
bindkey -M visual 'L' move-to-middle-line #  custom widget
bindkey -M visual 'P' end-of-line

bindkey -M visual 'o' yank_to_clipboard #  custom widget

# Insert Mode:
bindkey -M viins '\ei' beginning-of-line
bindkey -M viins '\eo' end-of-line

# Emacs binding addons:
bindkey -M viins '^P' history-search-backward
bindkey -M viins '^N' history-search-forward
bindkey -M viins '\ed' kill-word # del word after cursor
bindkey -M viins '^K' kill-line # del line after cursor

# Terminals/tty's already have ^W for del word before cursor and ^U for del line before cursor

# --------------------------------------------------------------------------

# reduce timeout for escape sequences
KEYTIMEOUT=1

setopt auto_cd

# History
HISTSIZE=15000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias nz='nvim ~/.zshrc'
alias sc='source ~/.config/zsh/.zshrc'
alias t='thunar' 
alias pn='pnpm'

alias lv='ls -1 --color'
alias ls='ls --color'
alias sl='ls --color' 
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias c='clear'
alias off='systemctl poweroff'

alias yasuf='yay -Syyu'
alias yacleanf='yay -Sc --noconfirm' 
alias parucleanf='paru -Sc --noconfirm' 

alias a='tmux a'
alias tls='tmux ls'
alias tks='tmux kill-server'

alias j='nvim' 
alias nvmin='NVIM_APPNAME=nvim-minimal nvim' 
alias sn='sudo -E nvim' 
alias code='code --use-gl=desktop'
alias rptn='repomix && thunar && hyprctl dispatch workspace 8'

alias ghc='gh copilot' 
alias ghcs='gh copilot suggest' 
alias ghce='gh copilot explain'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f "$HOME/.github_pat" ]; then
    source "$HOME/.github_pat"
fi

# --------------------------------------------------------------------------


# Start SSH agent if not running
# if [ -z "$SSH_AUTH_SOCK" ]; then
#    eval "$(ssh-agent -s)" > /dev/null
#    ssh-add ~/.ssh/id_github_sign_and_auth 2>/dev/null
# fi
 
if ! ps -p $SSH_AGENT_PID &> /dev/null; then
  ssh-agent > ~/.ssh/agent_out
  source ~/.ssh/agent_out &> /dev/null # check if SSH agent is running, start it if not
fi

# View man pages inside vim
export MANPAGER="vim -M +MANPAGER -"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH":"$HOME/.local/scripts/"
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/share/mysql/bin
export MANPATH="/usr/local/man:$MANPATH"

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

export PNPM_HOME="/home/maya/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd z zsh)"
# eval "$(starship init zsh)"

# ------------------------------------------------------------
# zprof | head -n 30  # Display the profiling report
