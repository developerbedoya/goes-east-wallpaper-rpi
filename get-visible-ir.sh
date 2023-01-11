#!/bin/bash
base_folder='/home/daniel/Pictures/weather.sh' # Must copy base images to this folder
grep_img_tag='<IMG[^>]*>'
grep_img_url='\"[^\"]*\"'
url_base="https://weather.msfc.nasa.gov"
lat=-19.999917
lon=-44.040917

# $1 => NASA API URL
# $2 => Image output filename
function getImageUrlFromNasaAPI() {
	echo "Downloading $2..."
	url_img=$url_base$(curl -s $1 | grep -o $grep_img_tag | grep -o $grep_img_url | head -n1 | sed 's/\"//g')
	curl -s $url_img -o $2
}

url_vis="https://weather.msfc.nasa.gov/cgi-bin/get-abi?satellite=GOESEastfullDiskband02&lat=$lat&lon=$lon&zoom=4&width=650&height=450&quality=100"
url_ir="https://weather.msfc.nasa.gov/cgi-bin/get-abi?satellite=GOESEastfullDiskband14&palette=ir2.pal&lat=$lat&lon=$lon&zoom=1&width=650&height=450&quality=100"
img_vis="$base_folder/vis.png"
img_ir="$base_folder/ir.png"

getImageUrlFromNasaAPI $url_vis $img_vis
getImageUrlFromNasaAPI $url_ir $img_ir

img_position="$base_folder/position.png"
img_result="$base_folder/current-weather.png"
img_date=$(date +"%d/%m/%Y %T")
img_archive="$base_folder/$(date +"%Y-%m-%d-%H-%M-%S").png"

convert $img_ir -alpha on -channel a -evaluate set 25% $img_ir
composite $img_ir $img_vis $img_result
composite $img_position $img_result $img_result
convert $img_result -fill white -undercolor '#00000080' -gravity SouthEast -annotate +5+5 " Updated: '$img_date' " $img_result
cp "$img_result" "$img_archive"

echo "Setando wallpaper..." && sleep 5;
sudo rm /etc/alternatives/desktop-background 
sudo ln -s $img_result /etc/alternatives/desktop-background

pid=$(ps -Ao pid,args | grep -E '[0-9]+ pcmanfm --desktop' | grep -Po '[0-9]+')
kill $pid
DISPLAY=:0 pcmanfm --desktop --profile LXDE-pi &
