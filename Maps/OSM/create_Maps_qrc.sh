#!/bin/sh

cd $(pwd)

rm -f ../../Maps.qrc
echo "
<RCC>
    <qresource prefix=\"/\">
" >> ../../Maps.qrc

for f in $(find . -name "*.png"| sed 's|^./||'); do
  echo "<file>./Maps/OSM/$f</file>" >> ../../Maps.qrc;
done

echo "
    </qresource>
</RCC>
" >> ../../Maps.qrc
