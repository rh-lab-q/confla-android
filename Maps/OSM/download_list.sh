#!/bin/sh




HERE=`pwd`

EXPECTED_PATH="$HOME/.local/share/Maps/OSM"

if [ "$HERE" != "$EXPECTED_PATH" ]; then
  echo "warning: "
  echo "  your path:    $HERE"
  echo "  expeced path: $EXPECTED_PATH"
  echo "  waiting 10 second ... (press ctrl-c to terminate)"
  sleep 3
fi


MAX_LAT=49.2322172 # 49.2460853
MIN_LAT=49.1889325 # 49.1672697

MAX_LON=16.6212656 # 16.6734269
MIN_LON=16.5693836 # 16.5452150

MAX_ZOOM=15
MIN_ZOOM=12

download_tile() {
  
  if [ ! -f "$PWD/$1/$2/$3.png" ]; then

    mkdir -p $1/$2
    cd $1/$2
    echo "downloading http://tile.openstreetmap.org/$1/$2/$3.png"
    wget -q "http://tile.openstreetmap.org/$1/$2/$3.png"
    cd $HERE
  fi


}

for zoom in $(seq $MIN_ZOOM $MAX_ZOOM); do

  max_val=`./deg2num.py $MAX_LAT $MAX_LON $zoom`
  min_val=`./deg2num.py $MIN_LAT $MIN_LON $zoom`

  x1=$(echo $min_val | cut -f 1 -d " ")
  x2=$(echo $max_val | cut -f 1 -d " ")

  y2=$(echo $min_val | cut -f 2 -d " ")
  y1=$(echo $max_val | cut -f 2 -d " ")


  for x in $(seq $x1 $x2); do 
    for y in $(seq $y1 $y2); do
      download_tile $zoom $x $y;
    done
  done

done


exit;

# download everything in smaller zooms than min

for zoom in $(seq 1 $MIN_ZOOM); do
  max_val=$(echo 2^$zoom -1|bc);
  for x in $(seq 0 $max_val); do
    for y in $(seq 0 $max_val); do
      download_tile $zoom $x $y;
    done
  done
done