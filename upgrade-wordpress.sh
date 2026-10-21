#!/bin/sh
set -eu

site=/var/www/html
backup="$site/.ptgis-security-update-20261021"
[ -f "$site/wp-load.php" ] || exit 0
[ ! -f "$backup/complete" ] || exit 0

mkdir -p "$backup"
printf 'Require all denied\n' > "$backup/.htaccess"
if [ ! -f "$backup/plugins-and-themes.tar.gz" ]; then
    tar -czf "$backup/plugins-and-themes.tar.gz.pending" -C "$site/wp-content" plugins themes
    mv "$backup/plugins-and-themes.tar.gz.pending" "$backup/plugins-and-themes.tar.gz"
fi
wp --path="$site" --skip-plugins --skip-themes plugin update --all
wp --path="$site" --skip-plugins --skip-themes theme update --all
wp --path="$site" eval 'echo "WordPress " . get_bloginfo("version") . " loaded on PHP " . PHP_VERSION . PHP_EOL;'
touch "$backup/complete"
