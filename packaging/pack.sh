#!/usr/bin/env zsh

set -euo pipefail

BUNDLE_IDENTIFIER='org.jyutping.inputmethod.Jyutping'
APP_VERSION='0.78.0'
INSTALL_LOCATION='/Library/Input Methods'

pkgbuild \
    --min-os-version 13.0 \
    --compression latest \
    --identifier "${BUNDLE_IDENTIFIER}" \
    --version "${APP_VERSION}" \
    --install-location "${INSTALL_LOCATION}" \
    --component-plist JyutpingComponent.plist \
    --root "app" \
    --scripts "scripts" \
    Jyutping-component.pkg

productbuild \
    --distribution distribution.xml \
    --resources resources \
    Jyutping.pkg
