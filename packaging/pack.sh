#!/usr/bin/env zsh

BUNDLE_IDENTIFIER='org.jyutping.inputmethod.Jyutping'
APP_VERSION='0.67.1'
INSTALL_LOCATION='/Library/Input Methods'

pkgbuild \
    --min-os-version 12.0 \
    --compression latest \
    --identifier "${BUNDLE_IDENTIFIER}" \
    --version "${APP_VERSION}" \
    --install-location "${INSTALL_LOCATION}" \
    --info PackageInfo \
    --component-plist JyutpingComponent.plist \
    --root "app" \
    --scripts "scripts" \
    Jyutping.pkg
