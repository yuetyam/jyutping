#!/bin/bash

BUNDLE_IDENTIFIER='org.jyutping.inputmethod.Jyutping'
APP_VERSION='0.18.0'

INSTALL_LOCATION='/tmp'

pkgbuild \
    --info PackageInfo \
    --root "app" \
    --component-plist JyutpingComponent.plist \
    --identifier "${BUNDLE_IDENTIFIER}" \
    --version "${APP_VERSION}" \
    --install-location "${INSTALL_LOCATION}" \
    --scripts "scripts" \
    Jyutping.pkg
