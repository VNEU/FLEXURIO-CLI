#!/usr/bin/env bash

python -m py_compile flexurio_portal
mv flexurio_portalc BUILD/flexurio_portal

shc -f install
mv install.x BUILD/install
rm -R install.x.c

shc -f flexurio
mv flexurio.x BUILD/flexurio
rm -R flexurio.x.c

chmod +x BUILD/*