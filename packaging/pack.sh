#!/bin/bash

BUNDLE_IDENTIFIER='org.jyutping.inputmethod.Jyutping'
APP_VERSION='0.21.0'

INSTALL_LOCATION='/Library/Input Methods'

WRONG_NAME_DIRECTORY='app/InputMethod.app'
if [ -d "${WRONG_NAME_DIRECTORY}" ]; then
  mv app/InputMethod.app app/Jyutping.app
fi

pkgbuild \
    --info PackageInfo \
    --root "app" \
    --component-plist JyutpingComponent.plist \
    --identifier "${BUNDLE_IDENTIFIER}" \
    --version "${APP_VERSION}" \
    --install-location "${INSTALL_LOCATION}" \
    --scripts "scripts" \
    Jyutping.pkg
