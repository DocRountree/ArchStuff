#!/usr/bin/env bash
# Assemble the Greenleaf archiso profile and build the ISO into build/out/.
#
# Usage: sudo tools/build-iso.sh
#        tools/build-iso.sh --assemble-only   (no root; just writes build/profile to inspect)
#
# Assembly: start from the installed archiso "releng" profile (so boot plumbing always
# matches your archiso version), drop releng's rescue-medium extras, overlay profile/,
# then run mkarchiso. Needs: archiso, and tools/build-repo.sh run first.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
build=$root/build
releng=${ARCHISO_RELENG:-/usr/share/archiso/configs/releng}
assemble_only=0
[[ ${1:-} == --assemble-only ]] && assemble_only=1
assembled=$build/profile
repo=$build/repo/x86_64

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

if [[ $assemble_only -eq 0 ]]; then
    [[ $EUID -eq 0 ]] || die "mkarchiso needs root: run 'sudo $0'"
    command -v mkarchiso >/dev/null || die "archiso isn't installed: sudo pacman -S archiso"
fi
[[ -d $releng ]] || die "releng profile not found at $releng"
[[ -f $repo/greenleaf.db ]] || die "no local repo yet: run tools/build-repo.sh (as your user) first"

rm -rf "$assembled"
cp -a "$releng" "$assembled"

# releng extras Greenleaf doesn't want: root autologin, ssh with empty root password,
# networkd/iwd (Greenleaf uses NetworkManager), speech, mirror chooser, VM agents, PXE hooks.
remove=(
    airootfs/etc/motd
    airootfs/etc/resolv.conf
    airootfs/etc/ssh/sshd_config.d/10-archiso.conf
    airootfs/etc/systemd/network
    airootfs/etc/systemd/networkd.conf.d
    airootfs/etc/systemd/resolved.conf.d
    airootfs/etc/systemd/system/getty@tty1.service.d
    airootfs/etc/systemd/system/choose-mirror.service
    airootfs/etc/systemd/system/livecd-alsa-unmuter.service
    airootfs/etc/systemd/system/livecd-talk.service
    airootfs/etc/systemd/system/cloud-init.target.wants
    airootfs/etc/systemd/system/multi-user.target.wants
    airootfs/etc/systemd/system/network-online.target.wants
    airootfs/etc/systemd/system/sockets.target.wants
    airootfs/etc/systemd/system/sound.target.wants
    airootfs/etc/systemd/system/systemd-networkd-wait-online.service.d
    airootfs/etc/systemd/system/dbus-org.freedesktop.ModemManager1.service
    airootfs/etc/systemd/system/dbus-org.freedesktop.network1.service
    airootfs/etc/systemd/system/dbus-org.freedesktop.resolve1.service
    airootfs/root/.automated_script.sh
    airootfs/root/.zlogin
    airootfs/usr/local/bin/choose-mirror
    airootfs/usr/local/bin/Installation_guide
    airootfs/usr/local/bin/livecd-sound
    airootfs/usr/local/share/livecd-sound
    efiboot/loader/entries/01-archiso-linux.conf
    efiboot/loader/entries/02-archiso-speech-linux.conf
    packages.aarch64
)
for path in "${remove[@]}"; do rm -rf -- "${assembled:?}/$path"; done

# Overlay Greenleaf's files (profiledef.sh is merged, not replaced).
releng_profiledef=$(cat "$assembled/profiledef.sh")
cp -a --remove-destination "$root/profile/." "$assembled/"
{
    printf '%s\n\n# ---- Greenleaf overrides (profile/profiledef.sh) ----\n' "$releng_profiledef"
    grep -v '^#!' "$root/profile/profiledef.sh"
} > "$assembled/profiledef.sh"

sed -i "s|@GREENLEAF_REPO@|$repo|" "$assembled/pacman.conf"
sed -i 's/^MENU TITLE .*/MENU TITLE Greenleaf/' "$assembled/syslinux/archiso_head.cfg"

# Live-only installer configs (Calamares) arrive in step 4; warn until then.
[[ -d $root/profile/airootfs/etc/calamares ]] || echo "warning: no Calamares config yet; the ISO will boot but can't install" >&2

if [[ $assemble_only -eq 1 ]]; then
    echo "Assembled profile: $assembled"
    exit 0
fi

mkarchiso -v -r -w "$build/work-iso" -o "$build/out" "$assembled"

if [[ -n ${SUDO_USER:-} ]]; then
    chown -R "$SUDO_USER:" "$build/out" "$assembled"
fi
echo
echo "ISO: $(ls -1t "$build"/out/*.iso | head -n1)"
echo "Test it: run_archiso -u -i <iso>   (UEFI)   or   run_archiso -i <iso>   (BIOS)"
