
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
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
ENABLE_CORRECTION="true"

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
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias nh='ngrok http --domain=complete-orca-major.ngrok-free.app '

watch() {
   nx test $1 --test-file $2 --watch
}

inout() {
    echo "The screen was on: "
    # Get the log and filter for display on/off events
    log=$(pmset -g log | grep "Display is turned")

    # Initialize variables
    prev_on=""
    prev_date=""

    # Process each line of the log
    while IFS= read -r line; do
        # Extract the timestamp and the event
        timestamp=$(echo "$line" | awk '{print $1 " " $2}')
        event=$(echo "$line" | grep -o "Display is turned [a-z]*")

        # Parse the date and time
        date=$(date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" "+%d")
        time=$(date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" "+%H:%M")

        if [[ $event == "Display is turned on" ]]; then
            # Save the on time and date
            prev_on=$time
            prev_date=$date
        elif [[ $event == "Display is turned off" && $prev_on != "" && $prev_date == $date ]]; then
            # Print the time span
            echo "${prev_date}th ${prev_on} -> ${time}"
            prev_on=""
        fi
    done <<< "$log"

    # Check if the display is currently on
    if [[ $prev_on != "" ]]; then
        echo "${prev_date}th ${prev_on} -> now"
    fi
}

help() {
    echo ""
    echo "-------------------------------------------------"
    echo "Custom functions are:"
    echo "watch - Run tests in watch mode"
    echo "      Usage: watch <project> <test-file>"
    echo ""
    echo "inout - Show the time span of the screen being on"
    echo "      Usage: inout"
    echo ""
    echo "nh - Start ngrok with a custom domain"
    echo "      Usage: nh <port>"
    echo "-------------------------------------------------"
    echo ""
    echo "Welcome to the terminal!"
}

help