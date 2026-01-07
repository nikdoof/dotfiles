# shellcheck shell=bash
# Terraform helpers

if [ -x "$(command -v terraform)" ]; then
    # Define a shared cache location for Terraform plugins
    export TF_PLUGIN_CACHE_DIR="${XDG_CACHE_HOME}/terraform-plugins"

    alias tfplan="terraform plan -out=tfplan.binary"
    alias tf="terraform"
fi
