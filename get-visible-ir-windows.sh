#!/bin/bash
grep_img_tag='<IMG[^>]*>'
grep_img_url='\"[^\"]*\"'
url_base="https://weather.msfc.nasa.gov"

# $1 => NASA API URL
# $2 => Image output filename
function getImageUrlFromNasaAPI() {
	echo "Downloading $2..."
	url_img=$url_base$(curl -s $1 | grep -o $grep_img_tag | grep -o $grep_img_url | head -n1 | sed 's/\"//g')
	curl -s $url_img -o $2
}

url_vis="https://weather.msfc.nasa.gov/cgi-bin/get-abi?satellite=GOESEastfullDiskband02&lat=-19.999917&lon=-44.040917&zoom=4&width=650&height=450&quality=100"
url_ir="https://weather.msfc.nasa.gov/cgi-bin/get-abi?satellite=GOESEastfullDiskband14&palette=ir2.pal&lat=-19.999917&lon=-44.040917&zoom=1&width=650&height=450&quality=100"
img_vis="vis.png"
img_ir="ir.png"

getImageUrlFromNasaAPI $url_vis $img_vis
getImageUrlFromNasaAPI $url_ir $img_ir

img_position="position.png"
img_result="current-weather.png"
win_dest="/mnt/c/temp/$img_result"
wallpaper_path="C:\temp\current-weather.png"
img_date=$(date +"%d/%m/%Y %T")

convert $img_ir -alpha on -channel a -evaluate set 25% $img_ir
composite $img_ir $img_vis $img_result
composite $img_position $img_result $img_result
convert $img_result -fill white -undercolor '#00000080' -gravity SouthEast -annotate +5+5 " Updated: '$img_date' " $img_result
mv $img_result $win_dest && echo "Copiando imagem para $win_dest..." && sleep 5;
/mnt/c/Windows/System32/reg.exe add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d $wallpaper_path /f
echo "Setando wallpaper..." && sleep 5;
/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters
/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters
/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters
