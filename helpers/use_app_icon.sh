#!/bin/bash

WORKDIR=$(mktemp -d)

ICONS_DIR="/opt/noVNC/app/images/icons"
HTML_FILE="/opt/noVNC/index.html"
UNIQUE_VERSION="$(date | md5sum | cut -c1-10)"

cp "$APP_ICON" "$ICONS_DIR/favicon.ico"

cat <<EOF > "$WORKDIR"/htmlCode
    <link rel="icon" href="favicon.ico?v=$UNIQUE_VERSION" />
EOF

cat "$HTML_FILE" | sed -ne "/<!-- BEGIN Favicons -->/ {p; r $WORKDIR/htmlCode" -e ":a; n; /<!-- END Favicons -->/ {p; b}; ba}; p" > "$WORKDIR"/tmp.html