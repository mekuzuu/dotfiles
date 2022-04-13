#key_bindings
fish_default_key_bindings

function attach_tmux_session_if_needed
    set ID (tmux list-sessions)
    if test -z "$ID"
        tmux new-session
        return
    end

    set new_session "Create New Session" 
    set ID (echo $ID\n$new_session | peco --on-cancel=error | cut -d: -f1)
    if test "$ID" = "$new_session"
        tmux new-session
    else if test -n "$ID"
        tmux attach-session -t "$ID"
    end
end

if test -z $TMUX && status --is-login
    attach_tmux_session_if_needed
end

# fish theme pure
set -x pure_symbol_prompt "( '_') <"

#view
set -g theme_display_date yes
set -g theme_display_git_master_branch yes
set -g theme_display_cmd_duration yes

set -g theme_title_display_user no
set -g theme_title_display_process yes
set -g theme_title_display_path no

#Go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
set -gx GO111MODULE on

#Rust
set -x PATH $HOME/.cargo/bin $PATH

#MySQL
set -x PATH $PATH /usr/local/opt/mysql@5.7/bin

#Java
set -x JAVA_HOME (/usr/libexec/java_home)

#Node
set -x PATH $HOME/.nodebrew/current/bin $PATH

#Python
set -x PYENV_ROOT $HOME/.pyenv
set -x PATH  $PYENV_ROOT/bin $PATH
pyenv init - | source

#alias
alias gl='goland .'
alias gc='git branch | peco | xargs git checkout'
alias gt='gitui'
alias scf='source .config/fish/config.fish'
alias vim='nvim'

#fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set -x FZF_DEFAULT_OPTS '--height 40% --reverse --border'
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
