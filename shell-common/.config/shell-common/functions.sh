# Git pulls latest dotfiles
function update-dotfiles() {
    prevdir=$PWD
    if [ -d "${HOME}/.dotfiles" ]; then
        cd $HOME/.dotfiles
        git pull --rebase --autostash
    fi
    if [ -d "${HOME}/.dotfiles-private" ]; then
        cd $HOME/.dotfiles-private
        git pull --rebase --autostash
    fi
    cd $prevdir
}

# Wrapper around ssh-add to ease usage and also ensure basic timeouts
function add-sshkey() {
    TIMEOUT="2h"
    NAME=$1

    if [ -z "$NAME" ]; then
        echo "Current Agent Keys"
        ssh-add -L | cut -d" " -f 3-
    else
        if [ -f "${HOME}/.ssh/id_ed25519_${NAME}" ]; then
            ssh-add -t $TIMEOUT "${HOME}/.ssh/id_ed25519_${NAME}"
        else
            echo "No key named ${NAME} found..."
        fi
    fi
}

# Switch to a simple prompt for demos (thanks Mark H for the idea)
function demoprompt() {
    if [ ! -z ${OLDPS1+x} ]; then
        PS1=$OLDPS1
        unset OLDPS1
    else
        OLDPS1=$PS1
        PS1=" %# "
        clear
    fi
}

# Tag the file as OK to run
function itsok() {
    if [[ $(uname) == "Darwin" ]]; then
        xattr -d com.apple.quarantine $1
    else
        echo 'This only works on macOS...'
    fi
}

# easy access to SSH
function awsssh() {
    local profile=""
    local region=""
    local username="ec2-user"
    local search=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --profile)
                profile="$2"
                shift 2
                ;;
            --region)
                region="$2"
                shift 2
                ;;
            *)
                search="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$search" ]]; then
        echo "Usage: awsssh [--profile prof] [--region reg] [user@]search-term"
        return 1
    fi

    # Extract username if provided as user@search
    if [[ "$search" == *@* ]]; then
        username="${search%@*}"
        search="${search#*@}"
    fi

    # Build AWS CLI options
    local aws_opts=()
    [[ -n "$profile" ]] && aws_opts+=(--profile "$profile")
    [[ -n "$region" ]] && aws_opts+=(--region "$region")

    # Get matching instances
    local instances
    instances=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=*$search*" \
        --query 'Reservations[].Instances[].{
            Name: Tags[?Key==`Name`].Value | [0],
            IP: PublicIpAddress,
            InstanceId: InstanceId
        }' \
        --output json \
        "${aws_opts[@]}")

    if [[ $? -ne 0 || -z "$instances" || "$instances" == "[]" ]]; then
        echo "Failed to retrieve instances or no match found."
        return 2
    fi

    # Select instance using fzf
    local selection
    selection=$(echo "$instances" | jq -r '.[] | "\(.Name): \(.IP // "no-ip") (\(.InstanceId))"' |
                fzf -1 -0 --header "Select an instance")

    if [[ -z "$selection" ]]; then
        echo "No valid instance selected."
        return 3
    fi

    # Extract IP and InstanceId from selection
    local ip instance_id
    ip=$(echo "$selection" | sed -E 's/.*: (.*) \(.*/\1/')
    instance_id=$(echo "$selection" | sed -E 's/.*\((i-[a-z0-9]+)\).*/\1/')

    if [[ "$ip" != "no-ip" ]]; then
        echo "Connecting to $username@$ip via SSH..."
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "${username}@${ip}"
    else
        echo "No public IP found. Falling back to AWS Session Manager..."
        aws ssm start-session --target "$instance_id" "${aws_opts[@]}"
    fi
}

function instances() {
    local profile=""
    local region=""

    # Parse optional arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --profile)
                profile="$2"
                shift 2
                ;;
            --region)
                region="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: list_ec2_instances [--profile prof] [--region region]"
                return 1
                ;;
        esac
    done

    # Build AWS CLI options
    local aws_opts=()
    [[ -n "$profile" ]] && aws_opts+=(--profile "$profile")
    [[ -n "$region" ]] && aws_opts+=(--region "$region")

    # Query EC2 for names and instance IDs
    aws ec2 describe-instances \
        --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], InstanceId: InstanceId}' \
        --output table \
        "${aws_opts[@]}"
}
