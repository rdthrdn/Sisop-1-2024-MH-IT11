#!/bin/bash

touch /home/rickomianto/sisop1/image.log

process() { 
    mkdir -p /home/rickomianto/sisop1/textfile
    mv /home/rickomianto/sisop1/*.txt /home/rickomianto/sisop1/textfile/

    for file in /home/rickomianto/sisop1/textfile/*.txt; do
        base64 -d "$file" > secret.txt
        regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
        string=$(cat secret.txt)
        if [[ $string =~ $regex ]]; then
           mv secret.txt $FILE_DIR
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [FOUND] [/home/rickomianto/sisop1/genshin_character/$file]" >> image.log
        break
    else
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [NOT FOUND] [/home/rickomianto/sisop1/genshin_character/$file]" >> image.log
    fi
    rm "$file"
done
    sleep 1
}

for region in Mondstat Liyue Fontaine Inazuma Sumeru; do
    pass=""
    for image in "/home/rickomianto/sisop1/genshin_character/$region"/*.jpg; do
        steghide extract -q -sf "$image" -p "$pass"
        process "$image"
    done
done

secret_link=$(cat "secret.txt")
wget -O gambar.jpg "$secret_link"
