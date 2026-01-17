# shellcheck shell=bash
# AWS functions

# Get the list of AWS profiles
function awsprofiles() {
    if ! [ -x $(command -v aws) ]; then
        echo "AWS CLI not installed."
        return 1
    fi
    profiles=$(aws --no-cli-pager configure list-profiles 2>/dev/null)
    if [[ -z "$profiles" ]]; then
        echo "No AWS profiles found in '$HOME/.aws/config, check if ~/.aws/config exists and properly configured.'"
        return 1
    else
        echo $profiles
    fi
}

# login via SSO to AWS
function awslogin() {
    for cmd in "aws" "fzf"; do
        if ! [ -x "$(command -v $cmd)" ]; then
            echo "$cmd is not installed. Please install it to use awslogin."
            return 1
        fi
    done

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
            echo "Usage: awslogin [--profile prof] [--region region]"
            return 1
            ;;
        esac
    done

    # Get available profiles
    local available_profiles
    available_profiles=$(aws --no-cli-pager configure list-profiles 2>/dev/null)
    if [[ -z "$available_profiles" ]]; then
        echo "No AWS profiles found in ~/.aws/config"
        return 1
    fi

    # If no profile provided, use fzf to select one
    if [[ -z "$profile" ]]; then
        profile=$(echo "$available_profiles" | fzf --header "Select AWS profile" --height 40%)
        if [[ -z "$profile" ]]; then
            echo "No profile selected."
            return 1
        fi
    else
        # Check if provided profile exists
        if ! echo "$available_profiles" | grep -qx "$profile"; then
            echo "Profile '$profile' not found. Searching for matches..."
            local matched_profiles
            matched_profiles=$(echo "$available_profiles" | grep -i "$profile")

            if [[ -z "$matched_profiles" ]]; then
                echo "No matching profiles found."
                return 1
            fi

            profile=$(echo "$matched_profiles" | fzf --header "Select AWS profile" --height 40%)
            if [[ -z "$profile" ]]; then
                echo "No profile selected."
                return 1
            fi
        fi
    fi

    # Build AWS CLI options
    local aws_opts=()
    [[ -n "$profile" ]] && aws_opts+=(--profile "$profile")
    [[ -n "$region" ]] && aws_opts+=(--region "$region")

    # Login via SSO
    aws sso login "${aws_opts[@]}"

    # Export AWS credentials
    while IFS= read -r line; do
        [[ -n "$line" ]] && eval "export $line"
    done < <(aws configure export-credentials --format env "${aws_opts[@]}")
    if [[ $? -ne 0 ]]; then
        echo "Failed to export AWS credentials."
        return 2
    fi
    echo "AWS login successful. Credentials exported."
    export AWS_PROFILE="$profile"
}

# Clear AWS credentials from environment
function awslogout() {
    if ! [ -x "$(command -v aws)" ]; then
        echo "AWS CLI not installed."
        return 1
    fi
    aws sso logout --profile "${AWS_PROFILE:-default}" 2>/dev/null
    unset AWS_PROFILE AWS_PROFILE_ACTIVE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_CREDENTIAL_EXPIRATION
    echo "AWS profile and credentials cleared."
}

# Check if AWS credentials have expired and clear the env variables if so
function _aws_creds_expiration_check() {
    if [[ -n "$AWS_CREDENTIAL_EXPIRATION" ]]; then
        local expiration_epoch
        local current_epoch

        # Convert expiration time to epoch (handles ISO 8601 format)
        if [[ -x $(command -v gdate) ]]; then
            # macOS with GNU coreutils installed
            expiration_epoch=$(gdate -d "$AWS_CREDENTIAL_EXPIRATION" +%s 2>/dev/null)
            current_epoch=$(gdate +%s)
        else
            # macOS with BSD date
            expiration_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$AWS_CREDENTIAL_EXPIRATION" +%s 2>/dev/null)
            current_epoch=$(date +%s)
        fi

        if [[ $? -eq 0 && -n "$expiration_epoch" ]]; then
            if [[ $current_epoch -ge $expiration_epoch ]]; then
                echo "AWS credentials have expired. Logging out..."
                awslogout
            fi
        fi
    fi
}

# Hook the expiration check to each prompt display
if [[ $(command add-zsh-hook 2>/dev/null) ]]; then
    # Zsh
    if ! [[ -n "$PERIOD" ]]; then
        export PERIOD=300
    fi
    add-zsh-hook periodic _aws_creds_expiration_check
else
    # Bash
    PROMPT_COMMAND="_aws_creds_expiration_check; $PROMPT_COMMAND"
fi
