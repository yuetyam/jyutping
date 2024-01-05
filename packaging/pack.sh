#!/usr/bin/env bash

BUNDLE_IDENTIFIER='org.jyutping.inputmethod.Jyutping'
APP_VERSION='0.33.0'

INSTALL_LOCATION='/Library/Input Methods'

pkgbuild \
    --info PackageInfo \
    --root "app" \
    --component-plist JyutpingComponent.plist \
    --identifier "${BUNDLE_IDENTIFIER}" \
    --version "${APP_VERSION}" \
    --install-location "${INSTALL_LOCATION}" \
    --scripts "scripts" \
    Jyutping.pkg
