# WordPress (MPM Patched)

This repository contains a wrapper script that disables additional MPMs (Multi-Processing Modules) which may conflict during startup, since only one MPM can be active at a time.

## Deploying

The easiest way to deploy this is by using the associated Railway template, which provides a one-lick, no-configuration deployment of WordPress with MariaDB.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/wordpress-mpm-patched?referralCode=uxuz)
