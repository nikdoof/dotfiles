
# Get the list of AWS profiles
function awsprofiles() {
  profiles=$(aws --no-cli-pager configure list-profiles 2> /dev/null)
  if [[ -z "$profiles" ]]; then
    echo "No AWS profiles found in '$HOME/.aws/config, check if ~/.aws/config exists and properly configured.'"
    return 1
  else
    echo $profiles
  fi
}

# login via SSO to AWS
function awslogin() {
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
                echo "Usage: awslogin --profile prof [--region region]"
                return 1
                ;;
        esac
    done

    # Check if profile is provided
    if [[ -z "$profile" ]]; then
        echo "Error: --profile parameter is required."
        echo "Usage: awslogin --profile prof [--region region]"
        return 1
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
    export AWS_PROFILE_ACTIVE="$profile"
    if [[ -n "$profile" ]]; then
        export AWS_PROFILE_DISPLAY="[aws: $profile]"
    else
        export AWS_PROFILE_DISPLAY=""
    fi
}

function awslogout() {
    unset AWS_PROFILE_ACTIVE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_CREDENTIAL_EXPIRATION
    export AWS_PROFILE_DISPLAY=""
    echo "AWS profile and credentials cleared."
}

function _aws_creds_expiration_check() {
    if [[ -n "$AWS_CREDENTIAL_EXPIRATION" ]]; then
        local expiration_epoch
        local current_epoch

        # Convert expiration time to epoch (handles ISO 8601 format)
        if command -v gdate &> /dev/null; then
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

# easy access to SSH
function awsssh() {
    local profile=""
    local region=""
    local username="ansible"
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
