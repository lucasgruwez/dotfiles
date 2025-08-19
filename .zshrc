# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export UNI="$HOME/Documents/UNI"

unit() {
    local target="$1"

    if [[ -z "$target" ]]; then
        echo "Usage: unit <unit-name>" >&2
        return 1
    fi

    # Save current dir so we can return to it if nothing found
    local curdir="$PWD"

    # Find the directory (case-insensitive, only directories, first match)
    local match
    match=$(find "$UNI" -type d -iname "*$target*" -print -quit)

    if [[ -n "$match" ]]; then
        cd "$match" || {
            echo "Failed to cd into '$match'" >&2
            cd "$curdir"
            return 1
        }
    else
        echo "No unit matching '$target' found in $UNI" >&2
        cd "$curdir"
        return 1
    fi
}

# Clean LaTeX auxiliary files in the current directory
latexclean() {
  emulate -L zsh
  setopt nullglob          # non-matching globs expand to nothing

  # Common LaTeX aux/extensions (+ a few useful extras)
  local -a exts=(
    aux bbl blg idx ind ilg log out toc lof lot fls fdb_latexmk
    nav snm vrb dvi ps bcf run.xml synctex.gz xdv
    acn acr alg glg glo gls ist
  )

  local -a files=()
  for ext in $exts; do
    files+=( *.$ext(N) )
  done

  # Extras that are directories or special files produced by some tools
  files+=( _minted-*(N/) )                 # minted temp dirs
  files+=( *-eps-converted-to.pdf(N) )     # epstopdf outputs
  files+=( texput.log(N) )                 # plain TeX log

  if (( ${#files} == 0 )); then
    print -r -- "No LaTeX auxiliary files found in $PWD."
    return 0
  fi

  print -r -- "Removing ${#files} item(s):"
  print -l -- $files
  rm -rf -- $files
}

zathura() {
    if [[ $# -eq 0 ]]; then
        # No arguments, just open the app
        open -a "/Applications/Zathura.app"
    else
        # Convert each argument to an absolute path
        local abs_paths=()
        for f in "$@"; do
            abs_paths+=("$(realpath "$f")")
        done
        open -a "/Applications/Zathura.app" --args "${abs_paths[@]}"
    fi
}
