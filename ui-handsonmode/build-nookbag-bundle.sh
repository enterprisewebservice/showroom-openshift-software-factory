#!/bin/sh
# Derivation for nookbag-handsonmode-v0.4.0.zip (checked in next to this
# script). Upstream nookbag hardcodes the demo.redhat.com favicon and the
# title "Showroom" in its index.html with no config hook, so the Hands-On
# Mode edition ships this patched copy of the pinned upstream release and
# the deployer points ZT_BUNDLE at it via file:// from the cloned repo.
# Re-run this after bumping UPSTREAM to regenerate the zip.
set -eu
UPSTREAM="https://github.com/rhpds/nookbag/releases/download/nookbag-v0.4.0/nookbag-v0.4.0.zip"
OUT="nookbag-handsonmode-v0.4.0.zip"

cd "$(dirname "$0")"
curl -sL -o "$OUT" "$UPSTREAM"
work=$(mktemp -d)
unzip -q "$OUT" index.html -d "$work"
sed -i.bak \
  -e 's|<link rel="icon"[^>]*/>|<link rel="icon" type="image/svg+xml" href="/_/img/favicon.svg" />|' \
  -e 's|<title>Showroom</title>|<title>Hands-On Mode</title>|' \
  "$work/index.html"
grep -q '/_/img/favicon.svg' "$work/index.html"
grep -q '<title>Hands-On Mode</title>' "$work/index.html"
(cd "$work" && zip -q "$OLDPWD/$OUT" index.html)
rm -rf "$work"
echo "wrote $OUT"
