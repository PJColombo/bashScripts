#!/usr/bin/env bash

# tr -d '\15\32' < winfile.txt > unixfile.txt
#tr -cd '\11\12\15\40-\176' < file-with-binary-chars > clean-file
N_PICTURES=5

show_help (){
    echo "-f <FILE> ----> It download the first 5 images for every line (program) in FILE. FILE must've been prepared previously using prepareWindowsFile.sh."
    echo "-s <FILE> ----> It rename every selected image write on FILE"
}

if [ $# -eq 0 ]; then
    show_help
    echo " Introduce an option"
    
else
    while getopts ":f:s:l:" opt
        do
            case ${opt} in
                 l)
                    N_PICTURES=${OPTARG}
                    ;;
                 f)
                    oldIFS=$IFS
                    IFS=''
                    first_iteration=true
                    channel=''
                    channelDir=''
                    programDir=''
                    file=$OPTARG
                    while read line
                        do
                        IFS=$oldIFS
                    #for line in $(cat $file) ; do
                        if [ "$first_iteration" = true ]; then
                            channel=$line
                            channelDir=`echo "$channel" | sed 's/ /-/g'`
                            echo $channelDir
                            first_iteration=false
                        else
                            echo $line
                            keyword="${line} ${channel}"
                            programDir=`echo "$channel" | sed 's/ /-/g'`
                            #We need to remove commas. Otherwise, it will split up the keyword.
                            keyword=`echo $keyword | sed 's/,/ /g'`
                            echo "Keyword: $keyword"
                            python ./Google-Image-Download-Script/google_images_download.py -k "$keyword" -l $N_PICTURES -o "${channel}"
                            echo "./${channel}/${keyword}/|" >> "${channelDir}SeletedImages.txt"
                            initialDir=$PWD
                            cd "${channel}/${keyword}/"
                            echo "Current directory is: $PWD"
                            i=0
                            for file in *jpg *png *svg
                            do
                                ext=${file##*.}
                                mv "$file" "img_${i}.${ext}"
                                ((i++))
                            done
                            cd "$initialDir"
                        fi
                     echo $line
                    #done
                    #IFS=''
                    done < "./${OPTARG}"
                    exit 0
                    ;;
                 s)
                    echo $opt
                    echo $OPTARG
                    oldIFS=$IFS
                    initialDir=$PWD
                    while IFS='' read -r line || [[ -n "$line" ]];
                    do
                        echo "Line read from file: $line"
                        direction=`echo $line | cut -d'|' -f1`
                        image=`echo $line | cut -d'|' -f2`
                        echo "First field: $direction"
                        echo "Second field: $image"
                        if [[ ! $image ]]; then
                            echo "---------------"
                            echo "---------------"
                            echo "No image was selected for the program ${direction}"
                            echo "---------------"
                            echo "---------------"
                        else
                            cd "$direction"
                            
                            mv "$image" "Selected${image}"
                            cd "$initialDir"
                        fi
                    done < ${OPTARG}
                    exit 0
                    ;;
                 *)
                    echo $opt
                    echo "An error has occured! Introduce an option."
                    exit 1
                    ;;
            esac
     done
fi
