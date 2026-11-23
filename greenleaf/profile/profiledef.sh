#!/usr/bin/env bash
# shellcheck disable=SC2034
# Greenleaf overrides. tools/build-iso.sh appends this file to the profiledef.sh of the
# installed archiso "releng" profile, so anything not set here is inherited from releng.

iso_name="greenleaf"
iso_label="GREENLEAF_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Greenleaf <https://github.com/DocRountree/ArchStuff>"
iso_application="Greenleaf live and install medium"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
arch="x86_64"
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
# Replaces releng's list entirely (several of releng's files are removed during assembly).
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d/live"]="0:0:440"
  ["/root"]="0:0:750"
  ["/root/.gnupg"]="0:0:700"
  ["/home/live"]="1000:1000:750"
  ["/usr/local/bin/greenleaf-installer"]="0:0:755"
)
