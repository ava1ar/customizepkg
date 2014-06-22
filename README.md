customizepkg
============

A tool for Arch Linux package manager pacman to modify PKGBUILD automatically.

# Usage: #

Without any parameters, it will read ./PKGBUILD and show any modifications that would be done.
Create config files with the same name as the package you want to modify, and place in either:
`/etc/customizepkg.d/` or `~/.customizepkg/`

The pacman wrapper "Yaourt" integrates with customizepkg by default

# Configuration file Syntax: #

````
ACTION#CONTEXT#PATTERN#VALUE 
````

- Action can be: remove, removeline, add or replace
- Context can be: depends, conflicts, makedepends etc.. or global for matching regexp in the whole PKGBUILD
- Pattern can be any rexgexp 
- Value (only needed for replace) can be any string
- Comments can be added by starting the line with `#`

# Additional Files #

You can add extra files to a PKGBUILD by placing them in `/etc/customizepkg.d/$PACKAGENAME.files/`
They will be added automatically, including checksums
