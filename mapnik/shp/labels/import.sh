#!/bin/bash -ex

for zoom in z9 z10; do
    for layer in points labels; do
        for region in africa asia australia-new-zealand europe north-america south-america; do

            if [ $region = 'europe' -a $zoom = 'z10' ]; then
                continue
            fi;
            
            ogr2ogr -t_srs "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs" $region-$layer-$zoom-merc.shp $region-$layer-$zoom.shp
            shp2pgsql -dID -s 900913 $region-$layer-$zoom-merc.shp ${region/-/_}_${layer}_$zoom
            rm -f $region-$layer-$zoom-merc.*
        
        done
    done
done

for zoom in z4 z5 z6 z7 z8 z9; do
    for layer in points labels; do
        for region in africa asia australia-new-zealand europe north-america south-america; do

            ogr2ogr -t_srs "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs" $region-$layer-$zoom-merc.shp $region-$layer-$zoom.shp
            
            if [ $region = 'africa' ]; then
                shp2pgsql -dID -s 900913 $region-$layer-$zoom-merc.shp city_${layer}_$zoom
            
            else
                shp2pgsql -aD -s 900913 $region-$layer-$zoom-merc.shp city_${layer}_$zoom
            fi
        
            rm -f $region-$layer-$zoom-merc.*
        
        done
    done
done
