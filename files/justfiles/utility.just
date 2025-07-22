# Apply SELinux type "user_home_t" on external drives to allow access from Trivalent
label-external-drives:
    #!/usr/bin/bash
    set -euo pipefail
    media_path="/run/media/$USER/"
    selabel="user_home_t"
    supported_fs=("ext2" "ext3" "ext4" "jfs" "xfs" "btrfs") # ref: https://wiki.gentoo.org/wiki/SELinux/FAQ#Can_I_use_SELinux_with_any_file_system.3F

    if [ -z "$( ls -A "$media_path" 2>&- )" ]; then
        echo "You don't have any drives mounted in \"$media_path\", aborting."
        exit 0
    fi
    echo "Warning: This will label your drives mounted on \"$media_path\" such that they are treated as an extension to your home directory. (You can select which ones to label)"
    echo 'If you do not want Trivalent to have access to these drives, do not proceed.'
    read -rp 'Are you sure you want to do this? [y/N] ' warning_proceed
    if ! [[ "$warning_proceed" == [Yy]* ]]; then
        echo 'Aborting.'
        exit 0
    fi

    for dir in "$media_path"*/
    do
        echo
        if [[ "$dir" =~ "'" ]]; then
            echo "WARNING: Single quotes in drive labels are forbidden to avoid command execution, skipping drive \"$dir\"..."
            continue
        fi
        if [[ "$(stat -c '%U' "$dir")" != "$USER" ]]; then
            echo "Drive root folder is not owned by you, skipping drive \"$dir\"..."
            continue
        fi
        detected_fs="$(df -T "$dir" | awk '{print $2}' | sed -n 2p)"
        if ! printf "%s\n" "${supported_fs[@]}" | grep -Fxq "$detected_fs"; then
            echo "SELinux support is unknown for filesystem $detected_fs, skipping drive \"$dir\"..."
            continue
        fi
        read -rp "Do you want to label \"$dir\"? [y/N] " proceed
        if ! [[ "$proceed" == [Yy]* ]]; then
            echo 'Skipping...'
            continue
        fi
        echo "Labeling drive mounted on \"$dir\" with $selabel"
        dir=${dir%*/} # remove trailing slash
        if ! run0 sh -c "semanage fcontext -a -t $selabel '$dir(/.*)?' && restorecon -r '$dir'"; then
            echo 'Execution failed, aborting.'
            exit 1
        fi
    done

    echo -e '\nDone.'
