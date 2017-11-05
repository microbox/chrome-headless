#!/usr/bin/env sh

# Allow the user to override command-line flags, bug #357629.
# This is based on Debian's chromium-browser package, and is intended
# to be consistent with Debian.
for f in /etc/chromium/*.conf; do
    [ -f ${f} ] && . "${f}"
done

# Prefer user defined CHROMIUM_USER_FLAGS (from env) over system
# default CHROMIUM_FLAGS (from /etc/chromium/chromium.conf).
CHROMIUM_USER=${CHROMIUM_USER:-chromium}
CHROMIUM_FLAGS=${CHROMIUM_USER_FLAGS:-"$CHROMIUM_FLAGS"}

# Let the wrapped binary know that it has been run through the wrapper
export CHROME_WRAPPER=$(readlink -f "$0")

PROGDIR=${CHROME_WRAPPER%/*}

case ":$PATH:" in
  *:$PROGDIR:*)
    # $PATH already contains $PROGDIR
    ;;
  *)
    # Append $PROGDIR to $PATH
    export PATH="$PATH:$PROGDIR"
    ;;
esac

CHROMIUM_USER_HOME=$(getent passwd ${CHROMIUM_USER} | cut -d: -f6)
CHROMIUM_USER_DATA=${CHROMIUM_USER_HOME}/.config/chromium-headless

CHROMIUM_FLAGS="--user-data-dir=${CHROMIUM_USER_DATA} ${CHROMIUM_FLAGS}"

# Set the .desktop file name
export CHROME_DESKTOP="chromium-headless.desktop"

# Run chromium as user instead of root
echo "Launching Chromium from $PROGDIR"
exec su - ${CHROMIUM_USER} -c "$PROGDIR/headless_shell $CHROMIUM_FLAGS $@"
