# Licensed under https://github.com/wpilibsuite/frc-docs-translations/blob/main/license.txt
#!/bin/sh
# update transifex pot and local po files

set -ex

LANG_TO_PULL=${1:-'es, fr_CA'}
LANG_MAP='es_MX: es,fr_CA: fr'
MAINPROJECT=ftcdocs
ORGANIZATION=first-inspires

# Set working directory to repo root
cd `dirname $0`/..

# Create POT Files
sphinx-build -T -b gettext $MAINPROJECT/docs/source locale/pot

# Update .tx/config
rm .tx/config
sphinx-intl create-txconfig
echo "lang_map = ${LANG_MAP}" >> .tx/config
sphinx-intl update-txconfig-resources -p locale/pot -d locale --transifex-project-name $MAINPROJECT --transifex-organization-name $ORGANIZATION

# Push and pull from Transifex. It is important to push then pull!
# If you pull then push, the PO files will contain out of date strings.
if [ "$CI" = true ]
then
    tx push --source --skip
fi
tx pull -l $LANG_TO_PULL -t --mode onlyreviewed --use-git-timestamps
