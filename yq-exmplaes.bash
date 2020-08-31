#bin/bash

YQ_COMMANDS=(
    'libraries'
    'libraries.(pkg_naming==raspberry-scripts-bash)'
    'libraries.(pkg_naming==raspberry-scripts-bash).git_remote'
    'libraries.(pkg_naming==raspberry-scripts-bash).git_branch'
    'libraries.(pkg_naming==raspberry-scripts-bash).bin_enable[*]'
    'libraries.(pkg_naming==raspberry-scripts-bash).bin_ignore[*]'
    'libraries.*.pkg_naming'
)

for c in "${YQ_COMMANDS[@]}"; do
    printf '\n## COMMAND: yq -e -P -C r script-libraries.yaml "%s"\n## RESULTS:\n' "${c}"
    yq -e -P -C r script-libraries.yaml "${c}"
    printf '\n'
done
