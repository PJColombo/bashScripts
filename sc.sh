#!/bin/bash
: '
i=0
while read -r  line
do
	echo $line
	echo "renaming file..."
	mv "$line" "file_${i}.jpg"
	((var+=1))
done <<< $(ls)
'
:'
#rename file function
i=0
for file in *.jpg *.png *.svg
do
	echo "vuelta ${i}"
	echo $file | grep ".jpg"
	isJPG="$?"
	echo $file | grep ".png"
	isPNG="$?"
	echo $file | grep ".svg"
	isSVG="$?"
	ext=''
	if [ $isJPG -eq 0 ]; then
		ext=".jpg"
	elif [ $isPNG -eq 0 ]; then
		ext=".png"
	elif [ $isSVG -eq 0 ]; then
		ext=".svg"
	fi
	mv "$file" "file_${i}${ext}"
	((i+=1))
done
'


oldIFS=$IFS
initialDir=$pwd
echo "My initial direction is $initialDIr"
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "Text read from file: $line"
	dir=`echo $line | cut -d' ' -f1`
	image=`echo $line | cut -d' ' -f2`
	echo "first field $dir"
	echo "second field $image"
	
	cd $dir
	for file in ls
	do
		if [ $file -ne $image ]; then
			rm $file
		fi
	done
	cd $initialDir
done < fichero.txt

