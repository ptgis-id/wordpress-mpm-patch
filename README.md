# WordPress (MPM Patched)

This repository contains a wrapper script that disables additional MPMs (Multi-Processing Modules) which may conflict during startup, since only one MPM can be active at a time.

## Deploying

The easiest way to deploy this is by using the associated Railway template, which provides a one-click, no-configuration deployment of WordPress with MariaDB.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/wordpress-mpm-patched?referralCode=uxuz)

## PTGIS production

Railway `landing-cms` follows this fork's `main` branch. Push changes here and wait
for the automatic deployment to succeed. The `/var/www/html` volume retains
WordPress core, plugins, themes, configuration and uploads; changing the image
updates PHP, but does not update the WordPress files already on that volume.

The image pins WordPress 7.1.3 with PHP 8.3.36 to address CVE-2026-109618 and
CVE-2026-109619. Until official WordPress images contain the fix, the Dockerfile
rebuilds PHP from its checksum-verified official release with the base image's
configure options, preserving the existing WordPress extensions. Remove that
rebuild when the official base image is patched. The build checks the PHP version,
required extensions and Apache configuration before it can deploy.

```sh
podman build -t ptgis-wordpress .
```

The first production startup also updates the installed plugins and themes using
WP-CLI. It saves their previous files under `.ptgis-security-update-20261021/`
on the volume, blocked from HTTP access with Apache `Require all denied`. A
`complete` marker prevents repeated updates on later starts. A database export
was taken separately before this release and remains local under ignored
`.local/`. Do not remove the marker unless intentionally retrying maintenance.
