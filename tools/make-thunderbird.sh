#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** uBlock0.thunderbird: Creating web store package"

BLDIR=dist/build
DES="$BLDIR"/uBlock0.thunderbird
rm -rf $DES
mkdir -p $DES

echo "*** uBlock0.thunderbird: copying common files"
bash ./tools/copy-common-files.sh  $DES

cp -R $DES/_locales/nb                 $DES/_locales/no

cp platform/thunderbird/manifest.json  $DES/
cp platform/firefox/webext.js          $DES/js/
cp platform/firefox/vapi-usercss.js    $DES/js/
cp platform/firefox/vapi-webrequest.js $DES/js/

echo "*** uBlock0.thunderbird: concatenating content scripts"
cat $DES/js/vapi-usercss.js > /tmp/contentscript.js
echo >> /tmp/contentscript.js
grep -v "^'use strict';$" $DES/js/vapi-usercss.real.js >> /tmp/contentscript.js
echo >> /tmp/contentscript.js
grep -v "^'use strict';$" $DES/js/contentscript.js >> /tmp/contentscript.js
mv /tmp/contentscript.js $DES/js/contentscript.js
rm $DES/js/vapi-usercss.js
rm $DES/js/vapi-usercss.real.js
rm $DES/js/vapi-usercss.pseudo.js

# Firefox/webext-specific
rm $DES/img/icon_128.png

echo "*** uBlock0.thunderbird: Generating meta..."
python tools/make-firefox-meta.py $DES/

if [ "$1" = all ]; then
    echo "*** uBlock0.thunderbird: Creating package..."
    pushd $DES > /dev/null
    zip ../$(basename $DES).xpi -qr *
    popd > /dev/null
elif [ -n "$1" ]; then
    echo "*** uBlock0.thunderbird: Creating versioned package..."
    pushd $DES > /dev/null
    zip ../$(basename $DES).xpi -qr *
    popd > /dev/null
    mv "$BLDIR"/uBlock0.thunderbird.xpi "$BLDIR"/uBlock0_"$1".thunderbird.xpi
fi

echo "*** uBlock0.thunderbird: Package done."
